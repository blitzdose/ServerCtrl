package de.blitzdose.webserver.auth.shiro;

import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.auth.UserDao;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;

public class SqliteRealm extends AuthorizingRealm {
    private final UserDao userDao;

    public SqliteRealm(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        Object principal = principals.getPrimaryPrincipal();
        User user;
        if (principal instanceof User) {
            user = (User) principal;
        } else if (principal instanceof String username) {
            user = userDao.findByUsername(username);
        } else {
            return null;
        }

        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        user.getRoleSets().forEach((id, roles) -> {
            roles.forEach(role -> info.addRole(id + ":" + role.name())); // e.g., "project1:ADMIN"
        });
        return info;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) {
        UsernamePasswordToken upToken = (UsernamePasswordToken) token;
        String username = upToken.getUsername();
        User user = userDao.findByUsername(username);

        if (user == null) throw new UnknownAccountException("User not found");

        return new SimpleAuthenticationInfo(user, user.getPassword(), getName());
    }
}