package de.blitzdose.serverctrl.common.web.auth;

import com.amdelamar.jotp.OTP;
import com.amdelamar.jotp.type.Type;
import de.blitzdose.serverctrl.common.crypt.CryptManager;
import de.blitzdose.serverctrl.common.web.Webserver;
import kotlin.Pair;
import org.jetbrains.annotations.Nullable;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;
import java.util.stream.Collectors;

public abstract class UserManager {
    static Map<String, TokenUser> tokens = new HashMap<>();

    public static final int SUCCESS = 1;
    public static final int WRONG_PASSWORD_OR_USERNAME = 2;
    public static final int WRONG_TOTP = 5;
    public static final int TOKEN_NOT_FOUND = 3;
    public static final int NO_PERMISSION = 4;

    @Nullable
    public abstract Set<String> getUsers();

    public abstract String getUserHash(String username);

    public abstract List<String> getAppHashes(String username);

    public abstract String getTOTPSecret(String username);

    public abstract List<String> getPermissions(String username);

    public abstract boolean userExists(String username);

    public abstract boolean hasTOTP(String username);

    public abstract boolean isTOTPPending(String username);

    public abstract String getPendingTOTPSecret(String username);

    public abstract void setPassword(String username, String newPasswordHash);

    public abstract void setUser(String username, String passwordHash);

    public abstract void deleteUser(String username);

    public abstract void setPermissions(String username, String[] rolesArray);

    public abstract void setPendingTOTPSecret(String username, String secret);

    public abstract void setTOTPSecret(String username, String secret);

    public abstract void setAppHashes(String username, List<String> appHashes);

    public void replaceOldHashes() {
        Set<String> usernames = getUsers();
        if (usernames == null) return;
        for (String user : usernames) {
            List<String> appHashes = getAppHashes(user);
            List<String> newAppHashes = new ArrayList<>();
            for (String appHash : appHashes) {
                Pair<String, String> newAppSaltHash = CryptManager.getPBKDF2Hash(appHash);
                if (appHash.startsWith("pbkdf2:") || newAppSaltHash == null) {
                    newAppHashes.add(appHash);
                    continue;
                }
                newAppHashes.add(String.format("pbkdf2:%s:%s", newAppSaltHash.component1(), newAppSaltHash.component2()));
            }
            setAppHashes(user, newAppHashes);

            String legacyHash = getUserHash(user);
            Pair<String, String> newSaltHash = CryptManager.getPBKDF2Hash(legacyHash);
            if (newSaltHash == null || legacyHash.startsWith("pbkdf2:")) continue;
            String newHash = String.format("pbkdf2:%s:%s", newSaltHash.component1(), newSaltHash.component2());
            setUser(user, newHash);
        }
    }

    public ArrayList<Role> getRoles(TokenUser user) {
        List<String> permissions = getPermissions(user.getUsername());
        return permissions.stream().map(Role::valueOf).collect(Collectors.toCollection(ArrayList::new));
    }

    public int authenticateUser(String username, String password, @Nullable String code) {
        String savedHash = getUserHash(username);
        List<String> savedAppHashes = getAppHashes(username);
        String hash;
        if (savedHash.startsWith("pbkdf2:")) {
            String[] savedHashPair = savedHash.split(":");
            byte[] salt = Base64.getUrlDecoder().decode(savedHashPair[1]);

            String legacyHash = CryptManager.getLegacyHash(password);
            if (legacyHash == null) return WRONG_PASSWORD_OR_USERNAME;
            Pair<String, String> hashPair = CryptManager.getPBKDF2Hash(salt, legacyHash);
            if (hashPair == null) return WRONG_PASSWORD_OR_USERNAME;
            hash = String.format("pbkdf2:%s:%s", hashPair.component1(), hashPair.component2());
        } else {
            hash = CryptManager.getLegacyHash(password);
        }

        String totpSecret = getTOTPSecret(username);
        if (hash != null && !hash.isEmpty() && isInAppHashes(savedAppHashes, password)) {
            savedHash = hash;
        } else {
            if (totpSecret != null) {
                if (!checkTOTP(totpSecret, code)) {
                    return WRONG_TOTP;
                }
            }
        }
        if (hash != null && !hash.isEmpty() && Objects.equals(savedHash, hash)) {
            List<String> permissions = getPermissions(username);
            ArrayList<Role> roles = new ArrayList<>();
            permissions.forEach(s -> {
                try {
                    roles.add(Role.valueOf(s));
                } catch (IllegalArgumentException e) {
                    Webserver.logger.error("Invalid permission \"" + s + "\" at user \"" + username + "\". Check the config.yml");
                }
            });
            tokens.put(generateNewToken(), new TokenUser(username, System.currentTimeMillis(), roles));
            return SUCCESS;
        } else {
            return WRONG_PASSWORD_OR_USERNAME;
        }
    }

    private boolean isInAppHashes(List<String> savedAppHashes, String password) {
        for (String appHash : savedAppHashes) {
            String hash;
            if (appHash.startsWith("pbkdf2:")) {
                String[] savedHashPair = appHash.split(":");
                byte[] salt = Base64.getUrlDecoder().decode(savedHashPair[1]);

                String legacyHash = CryptManager.getLegacyHash(password);
                if (legacyHash == null) continue;
                Pair<String, String> hashPair = CryptManager.getPBKDF2Hash(salt, legacyHash);
                if (hashPair == null) continue;
                hash = String.format("pbkdf2:%s:%s", hashPair.component1(), hashPair.component2());
            } else {
                hash = CryptManager.getLegacyHash(password);
            }
            if (Objects.equals(hash, appHash)) return true;
        }
        return false;
    }

    public int authenticateUser(String token, Role role) {
        if (tokens.containsKey(token)) {
            TokenUser tokenUser = tokens.get(token);
            if (getRoles(tokenUser).contains(role)) {
                if (tokenUser.getUpdatedDateMillis() + (1000 * 60 * 60 * 48) > System.currentTimeMillis()) {
                    return SUCCESS;
                } else {
                    tokens.remove(token);
                    return TOKEN_NOT_FOUND;
                }
            } else {
                return NO_PERMISSION;
            }
        } else {
            return TOKEN_NOT_FOUND;
        }
    }

    public int authenticateUser(String token) {
        if (tokens.containsKey(token)) {
            TokenUser tokenUser = tokens.get(token);
            if (tokenUser.getUpdatedDateMillis() + (1000 * 60 * 60 * 48) > System.currentTimeMillis()) {
                return SUCCESS;
            } else {
                tokens.remove(token);
                return TOKEN_NOT_FOUND;
            }
        } else {
            return TOKEN_NOT_FOUND;
        }
    }

    public String getToken(String username) {
        for (String token : tokens.keySet()) {
            TokenUser tokenUser = tokens.get(token);
            if (tokenUser.getUsername().equals(username)) {
                return token;
            }
        }
        return "";
    }

    public String getUsername(String token) {
        String username = "";
        if (tokens.containsKey(token)) {
            username = tokens.get(token).getUsername();
        }
        return username;
    }

    public static String generateNewToken() {
        byte[] randomBytes = new byte[24];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().encodeToString(randomBytes);
    }

    public ArrayList<String> getPermissions(String username, boolean cumulative) {
        TokenUser user = tokens.get(getToken(username));
        ArrayList<String> permissions = new ArrayList<>();
        if (user == null) {
            List<String> rolesStrList = getPermissions(username);
            ArrayList<Role> roles = rolesStrList.stream().map(Role::valueOf).collect(Collectors.toCollection(ArrayList::new));
            user = new TokenUser(username, System.currentTimeMillis(), roles);
        }
        if (getRoles(user).contains(Role.ADMIN) && cumulative) {
            permissions.addAll(Arrays.stream(Role.values()).map(Enum::name).filter(s -> !s.equals("ANYONE")).toList());
        } else {
            getRoles(user).forEach(role -> permissions.add(role.name()));
        }
        return permissions;
    }

    public ArrayList<Role> getRoles(String token) {
        TokenUser user = tokens.get(token);
        if (user != null) {
            return getRoles(user);
        }
        return null;
    }

    public void logout(String username) {
        tokens.remove(getToken(username));
    }

    public boolean hasPermission(Role role, String token) {
        TokenUser user = tokens.get(token);
        return user != null && getRoles(user).contains(role);
    }

    public boolean createUser(String username, String password) {
        String legacyHash = CryptManager.getLegacyHash(password);
        if (legacyHash == null || userExists(username)) {
            return false;
        }
        Pair<String, String> passwordHash = CryptManager.getPBKDF2Hash(legacyHash);
        setUser(username, String.format("pbkdf2:%s:%s", passwordHash.component1(), passwordHash.component2()));
        return true;
    }

    public boolean setRoles(String username, List<Role> roles) {
        if (!userExists(username)) {
            return false;
        }
        String[] rolesArray = roles.stream().map(Enum::name).filter(s -> !s.equals("ANYONE")).toArray(String[]::new);
        setPermissions(username, rolesArray);
        return true;
    }

    public void setRole(String username, Role role, boolean state) {
        if (!userExists(username)) {
            return;
        }
        List<String> givenRoles = getPermissions(username);
        if (givenRoles.contains(role.name()) && !state) {
            givenRoles.remove(role.name());
        } else if (!givenRoles.contains(role.name()) && state) {
            givenRoles.add(role.name());
        }
        setPermissions(username, givenRoles.toArray(String[]::new));
    }

    @Nullable
    public String initTOTP(String username) {
        String secret = OTP.randomBase32(20);
        if (!userExists(username) || hasTOTP(username)) {
            return null;
        }

        setPendingTOTPSecret(username, secret);
        return secret;
    }

    public boolean verifyTOTP(String username, String code) throws IOException, NoSuchAlgorithmException, InvalidKeyException {
        if (!isTOTPPending(username)) {
            return false;
        }
        String secret = getPendingTOTPSecret(username);
        if (secret == null) {
            return false;
        }

        if (checkTOTP(secret, code)) {
            setTOTPSecret(username, secret);
            return true;
        }
        return false;
    }

    private boolean checkTOTP(String secret, String code) {
        try {
            String code1 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis() - 30000), 6, Type.TOTP);
            String code2 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis()), 6, Type.TOTP);
            String code3 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis() + 30000), 6, Type.TOTP);

            return code1.equals(code) || code2.equals(code) || code3.equals(code);
        } catch (InvalidKeyException | NoSuchAlgorithmException | IOException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean removeTOTP(String username, String code) {
        if (!userExists(username) || !hasTOTP(username)) {
            return false;
        }

        setTOTPSecret(username, null);
        return true;
    }

    @Nullable
    public String createAppPassword(String username) {
        if (!userExists(username)) {
            return null;
        }
        String appPassword = OTP.randomBase32(128);
        String legacyHash = CryptManager.getLegacyHash(appPassword);
        Pair<String, String> appPasswordHash = CryptManager.getPBKDF2Hash(legacyHash);

        List<String> appPasswords = getAppHashes(username);
        appPasswords.add(String.format("pbkdf2:%s:%s", appPasswordHash.component1(), appPasswordHash.component2()));
        setAppHashes(username, appPasswords);
        return appPassword;
    }
}
