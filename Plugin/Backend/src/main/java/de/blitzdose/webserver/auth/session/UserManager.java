package de.blitzdose.webserver.auth.session;

import de.blitzdose.webserver.auth.Role;
import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.auth.UserDao;
import jakarta.servlet.http.HttpSession;
import org.jdbi.v3.core.Jdbi;

import java.security.PublicKey;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class UserManager {

    private final Jdbi jdbi;

    public UserManager(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public User getUser(HttpSession httpSession) throws UserManagerException, IllegalStateException {
        String username = (String) httpSession.getAttribute("user");
        if (username == null) throw new UserManagerException("Session has no user");
        User user = getUserByUsername(username);
        if (user == null) throw new UserManagerException("Invalid user");
        return user;
    }

    public User getUserByUsername(String username) {
        return jdbi.onDemand(UserDao.class).findByUsername(username);
    }

    public User login(String username, String password, String code) throws UserManagerException {
        User user = getUserByUsername(username);
        String savedHash = user.getPassword();

        if (!PasswordVerifier.verify(password, savedHash)) {
            throw new UserManagerException.WrongCredentialsException(username);
        }

        if (TOTPVerifier.checkTOTP(user.getTotpSecret(), code)) {
            return user;
        } else {
            throw new UserManagerException.WrongTOTPException(username);
        }
    }

    public User pubkeyLogin(String username, String publicKeyHash, String challengeId, byte[] signature) throws UserManagerException {
        if (PublicKeyVerifier.verify(username, publicKeyHash, challengeId, signature)) {
            return getUserByUsername(username);
        } else {
            throw new UserManagerException.WrongCredentialsException(username);
        }
    }

    public void logout(HttpSession session) {
        session.invalidate();
    }

    public void changePassword(User user, String newPassword) {
        user.setPassword(PasswordVerifier.encrypt(newPassword));
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public void removeTOTP(User user) {
        user.setTotpSecret(null);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public String initTOTP(User user) {
        String secret = TOTPVerifier.generateSecret();
        user.setTotpSecret("$" + secret);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
        return secret;
    }

    public boolean verifyTOTP(User user, String code) {
        String secret = TOTPVerifier.verifyTOTP(user.getTotpSecret(), code);
        if (secret == null) {
            return false;
        } else {
            user.setTotpSecret(secret);
            jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
            return true;
        }
    }

    public List<User> getUsers() {
        return jdbi.onDemand(UserDao.class).listAllUsers();
    }

    public void setRoles(User user, String system, List<Role> roles) {
        Map<String, List<Role>> roleSets = user.getRoleSets();
        roleSets.put(system, roles);
        user.setRoleSets(roleSets);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public void createUser(String username, String password) throws UserManagerException.UserExistsException, UserManagerException.InvalidUsernameException {
        if (getUserByUsername(username) != null) {
            throw new UserManagerException.UserExistsException(username);
        }
        if (!Pattern.matches("^([a-zA-Z0-9]+)$", username) || password.isEmpty()) {
            throw new UserManagerException.InvalidUsernameException(username);
        }
        User user = new User(username, PasswordVerifier.encrypt(password), false);
        jdbi.useExtension(UserDao.class, dao -> dao.insertUser(user));
    }

    public void deleteUser(User user) {
        jdbi.useExtension(UserDao.class, dao -> dao.deleteByUsername(user.getUsername()));
    }

    public void setSuperAdmin(User user, boolean superAdmin) {
        user.setSuperAdmin(superAdmin);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public void addPublicKey(User user, PublicKey publicKey) {
        user.addPublicKey(publicKey);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public static class UserManagerException extends Exception {

        private final String username;

        UserManagerException(String username) {
            this.username = username;
        }

        public String getUsername() {
            return username;
        }

        public static class WrongCredentialsException extends UserManagerException {
            WrongCredentialsException(String username) {
                super(username);
            }
        }
        public static class WrongTOTPException extends UserManagerException {
            WrongTOTPException(String username) {
                super(username);
            }
        }
        public static class UserExistsException extends UserManagerException {
            UserExistsException(String username) {
                super(username);
            }
        }
        public static class InvalidUsernameException extends UserManagerException {
            InvalidUsernameException(String username) {
                super(username);
            }
        }
    }
}
