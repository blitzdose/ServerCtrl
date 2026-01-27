package de.blitzdose.webserver.auth.shiro;

import de.blitzdose.webserver.auth.Role;
import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.auth.UserDao;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.PasswordService;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.SessionException;
import org.apache.shiro.session.mgt.DefaultSessionKey;
import org.apache.shiro.session.mgt.DefaultSessionManager;
import org.apache.shiro.session.mgt.eis.SessionDAO;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.subject.support.DefaultSubjectContext;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class UserManager {

    private final DefaultSessionManager sessionManager;
    private final PasswordService passwordService;
    private final Jdbi jdbi;

    public UserManager(DefaultSessionManager sessionManager, PasswordService passwordService, Jdbi jdbi) {
        this.sessionManager = sessionManager;
        this.passwordService = passwordService;
        this.jdbi = jdbi;
    }

    public User getUser(String token) throws UserManagerException {
       Subject currentUser = getUserSubject(token);
       return (User) currentUser.getPrincipal();
    }

    public User getUserByUsername(String username) {
        return jdbi.onDemand(UserDao.class).findByUsername(username);
    }

    private Subject getUserSubject(String token) throws UserManagerException {
        Subject currentUser = null;
        try {
            if (token != null) {
                currentUser = new Subject.Builder()
                        .session(sessionManager.getSession(new DefaultSessionKey(token)))
                        .buildSubject();
            }
        } catch (SessionException ignored) {}
        if (currentUser == null || !currentUser.isAuthenticated()) {
            throw new UserManagerException.WrongCredentialsException("");
        }
        return currentUser;
    }

    public Subject login(String username, String password, String code) throws UserManagerException {
        Subject currentUser = SecurityUtils.getSubject();
        try {
            currentUser.login(new UsernamePasswordToken(
                    username,
                    password
            ));
        } catch (AuthenticationException ignored) {
            throw new UserManagerException.WrongCredentialsException(username);
        }
        if (currentUser.isAuthenticated()) {
            User user = (User) currentUser.getPrincipal();
            if (TOTPManager.checkTOTP(user.getTotpSecret(), code)) {
                return currentUser;
            } else {
                throw new UserManagerException.WrongTOTPException(username);
            }
        } else {
            throw new UserManagerException.WrongCredentialsException(username);
        }
    }

    public void logout(String token) throws UserManagerException {
        Subject currentUser = getUserSubject(token);
        currentUser.logout();
    }

    public void logout(User user) {
        SessionDAO sessionDAO = sessionManager.getSessionDAO();

        for (Session session : sessionDAO.getActiveSessions()) {
            PrincipalCollection pc = (PrincipalCollection) session.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
            if (pc != null && user.getUsername().equals(pc.getPrimaryPrincipal())) {
                session.stop();
                sessionDAO.delete(session);
            }
        }
    }

    public void changePassword(User user, String newPassword) {
        user.setPassword(passwordService.encryptPassword(newPassword));
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));

    }

    public void removeTOTP(User user) {
        user.setTotpSecret(null);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
    }

    public String initTOTP(User user) {
        String secret = TOTPManager.generateSecret();
        user.setTotpSecret("$" + secret);
        jdbi.useExtension(UserDao.class, dao -> dao.updateUser(user));
        return secret;
    }

    public boolean verifyTOTP(User user, String code) {
        String secret = TOTPManager.verifyTOTP(user.getTotpSecret(), code);
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
        User user = new User(username, passwordService.encryptPassword(password), false);
        jdbi.useExtension(UserDao.class, dao -> dao.insertUser(user));
    }

    public void deleteUser(User user) {
        logout(user);
        jdbi.useExtension(UserDao.class, dao -> dao.deleteByUsername(user.getUsername()));
    }

    public void setSuperAdmin(User user, boolean superAdmin) {
        user.setSuperAdmin(superAdmin);
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
