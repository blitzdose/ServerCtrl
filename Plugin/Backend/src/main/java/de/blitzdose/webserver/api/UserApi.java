package de.blitzdose.webserver.api;

import de.blitzdose.webserver.WebServer;
import de.blitzdose.webserver.auth.Role;
import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.auth.shiro.UserManager;
import de.blitzdose.webserver.logging.SecurityLogType;
import io.javalin.http.Context;
import io.javalin.http.Cookie;
import io.javalin.http.SameSite;
import org.apache.shiro.subject.Subject;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class UserApi {
    public static void login(Context context) throws UserManager.UserManagerException {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String username = data.getString("username");
        String passwordBase64 = data.getString("password");
        String code = data.optString("code", "");
        String password = new String(Base64.getUrlDecoder().decode(passwordBase64.trim()), StandardCharsets.UTF_8);

        Subject subject = WebServer.userManager.login(username, password, code);

        String token = subject.getSession().getId().toString();
        Cookie cookie = new Cookie(
                "token",
                token,
                "/",
                2592000,
                false,
                0,
                false,
                null,
                null,
                SameSite.LAX
        );
        context.cookie(cookie);
        WebServer.returnSuccessfulJson(context, new JSONObject());
        WebServer.securityLog(SecurityLogType.LOGIN_SUCCESS, username, "User successfully logged in");
    }

    public static void getCurrent(Context context) {
        User user = Objects.requireNonNull(context.attribute("user"));
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", user.getUsername()));
    }

    public static void getPermissions(Context context) {
        User user = Objects.requireNonNull(context.attribute("user"));

        Map<String, List<Role>>  roles = user.getRoleSets();
        WebServer.returnSuccessfulJson(context,
                new JSONObject().put("data",
                        new JSONObject()
                                .put("superAdmin", user.isSuperAdmin())
                                .put("permissions", new JSONObject(roles))
                )
        );
    }

    public static void logout(Context context) throws UserManager.UserManagerException {
        WebServer.userManager.logout(context.cookie("token"));
        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void changePassword(Context context) throws UserManager.UserManagerException {
        User user = Objects.requireNonNull(context.attribute("user"));
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String passwordBase64 = data.getString("password");
        String newPasswordBase64 = data.getString("newPassword");
        String code = data.getString("code");

        if (passwordBase64 == null || newPasswordBase64 == null) {
            WebServer.returnUnauthorized(context);
            return;
        }

        String password = new String(Base64.getUrlDecoder().decode(passwordBase64));
        String newPassword = new String(Base64.getUrlDecoder().decode(newPasswordBase64));

        WebServer.userManager.login(user.getUsername(), password, code);
        WebServer.userManager.changePassword(user, newPassword);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void initTOTP(Context context) throws UserManager.UserManagerException {
        User user = context.attribute("user");
        String passwordBase64 = WebServer.getData(context, String.class);

        if (user == null || passwordBase64 == null) {
            WebServer.returnUnauthorized(context);
            return;
        }

        String password = new String(Base64.getUrlDecoder().decode(passwordBase64));
        WebServer.userManager.login(user.getUsername(), password, null);

        String secret = WebServer.userManager.initTOTP(user);
        if (secret != null) {
            WebServer.returnSuccessfulJson(context, new JSONObject().put("data", secret));
        } else {
            WebServer.returnFailedJson(context);
        }
    }

    public static void verifyTOTP(Context context) {
        User user = Objects.requireNonNull(context.attribute("user"));
        String code = WebServer.getData(context, String.class);

        boolean success = WebServer.userManager.verifyTOTP(user, code);
        if (success) {
            WebServer.returnSuccessfulJson(context, new JSONObject());
        } else {
            WebServer.returnFailedJson(context);
        }
    }

    public static void removeTOTP(Context context) throws UserManager.UserManagerException {
        User user = Objects.requireNonNull(context.attribute("user"));
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String passwordBase64 = data.getString("password");
        String code = data.getString("code");

        if (passwordBase64 == null) {
            WebServer.returnUnauthorized(context);
            return;
        }

        String password = new String(Base64.getUrlDecoder().decode(passwordBase64));

        WebServer.userManager.login(user.getUsername(), password, code);
        WebServer.userManager.removeTOTP(user);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void hasTOTP(Context context) {
        User user = Objects.requireNonNull(context.attribute("user"));
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", user.getTotpSecret() != null));
    }
}
