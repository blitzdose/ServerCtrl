package de.blitzdose.minecraftserverremote.web.webserver.auth;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.crypt.CryptManager;
import de.blitzdose.minecraftserverremote.logging.Logger;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.Plugin;

import java.security.SecureRandom;
import java.util.*;
import java.util.stream.Collectors;

public class UserManager {

    static Map<String, TokenUser> tokens = new HashMap<>();

    public static final int SUCCESS = 1;
    public static final int WRONG_PASSWORD_OR_USERNAME = 2;
    public static final int TOKEN_NOT_FOUND = 3;
    public static final int NO_PERMISSION = 4;

    public UserManager() { }

    public int authenticateUser(String username, String hash) {
        Plugin plugin = ServerCtrl.getPlugin();
        String savedHash = plugin.getConfig().getString("Webserver.users." + username);
        if (hash != null && !hash.isEmpty() && Objects.equals(savedHash, hash)) {
            List<String> permissions = plugin.getConfig().getStringList("Webserver.permissions." + username);
            ArrayList<Role> roles = new ArrayList<>();
            permissions.forEach(s -> {
                try {
                    roles.add(Role.valueOf(s));
                } catch (IllegalArgumentException e) {
                    Logger.error("Invalid permission \"" + s + "\" at user \"" + username + "\". Check the config.yml");
                }
            });
            tokens.put(generateNewToken(), new TokenUser(username, System.currentTimeMillis(), roles));
            return SUCCESS;
        } else {
            return WRONG_PASSWORD_OR_USERNAME;
        }
    }

    public int authenticateUser(String token, Role role) {
        if (tokens.containsKey(token)) {
            TokenUser tokenUser = tokens.get(token);
            if (tokenUser.getRoles().contains(role)) {
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
            List<String> rolesStrList = ServerCtrl.getPlugin().getConfig().getStringList("Webserver.users." + username);
            ArrayList<Role> roles = rolesStrList.stream().map(Role::valueOf).collect(Collectors.toCollection(ArrayList::new));
            user = new TokenUser(username, System.currentTimeMillis(), roles);
        }
        if (user.getRoles().contains(Role.ADMIN) && cumulative) {
            permissions.addAll(Arrays.stream(Role.values()).map(Enum::name).filter(s -> !s.equals("ANYONE")).collect(Collectors.toList()));
        } else {
            user.getRoles().forEach(role -> permissions.add(role.name()));
        }
        return permissions;
    }

    public ArrayList<Role> getRoles(String token) {
        TokenUser user = tokens.get(token);
        if (user != null) {
            return user.getRoles();
        }
        return null;
    }

    public void logout(String username) {
        tokens.remove(getToken(username));
    }

    public boolean hasPermission(Role role, String token) {
        TokenUser user = tokens.get(token);
        return user != null && user.getRoles().contains(role);
    }

    public void setPassword(String username, String newPasswordHash) {
        Plugin plugin = ServerCtrl.getPlugin();
        plugin.getConfig().set("Webserver.users." + username, newPasswordHash);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    public boolean createUser(String username, String password) {
        String passwordHash = CryptManager.getHash(password);
        if (passwordHash == null) {
            return false;
        }
        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        if (config.contains("Webserver.users." + username)) {
            return false;
        }
        config.set("Webserver.users." + username, passwordHash);
        ServerCtrl.getPlugin().saveConfig();
        ServerCtrl.getPlugin().reloadConfig();
        return true;
    }

    public boolean setRoles(String username, List<Role> roles) {
        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        if (!config.contains("Webserver.users." + username)) {
            return false;
        }
        String[] rolesArray = roles.stream().map(Enum::name).filter(s -> !s.equals("ANYONE")).toArray(String[]::new);
        config.set("Webserver.permissions." + username, rolesArray);
        ServerCtrl.getPlugin().saveConfig();
        ServerCtrl.getPlugin().reloadConfig();
        return true;
    }

    public boolean setRole(String username, Role role, boolean state) {
        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        if (!config.contains("Webserver.users." + username)) {
            return false;
        }
        List<String> givenRoles = config.getStringList("Webserver.permissions." + username);
        if (givenRoles.contains(role.name()) && !state) {
            givenRoles.remove(role.name());
        } else if (!givenRoles.contains(role.name()) && state) {
            givenRoles.add(role.name());
        }
        config.set("Webserver.permissions." + username, givenRoles);
        ServerCtrl.getPlugin().saveConfig();
        ServerCtrl.getPlugin().reloadConfig();
        return true;
    }
}
