package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.crypt.CryptManager;
import de.blitzdose.minecraftserverremote.logging.LoggingSaver;
import de.blitzdose.minecraftserverremote.logging.LoggingType;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.http.Context;
import io.javalin.http.Cookie;
import io.javalin.http.SameSite;
import org.eclipse.jetty.http.HttpStatus;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Base64;

public class UserApi {
    public static void login(Context context, UserManager userManager) {
        String username = context.formParam("username");
        String passwordBase64 = context.formParam("password");
        String password;
        String passwordHash = null;
        if (passwordBase64 != null) {
            password = new String(Base64.getUrlDecoder().decode(passwordBase64.trim()));
            passwordHash = CryptManager.getHash(password);
        }
        if (username == null || passwordHash == null) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }

        int result = userManager.authenticateUser(username, passwordHash);
        if (result == UserManager.SUCCESS) {
            LoggingSaver.addLogEntry(LoggingType.LOGIN_SUCCESS, username + " (" + context.ip() + ")");
            JSONObject resultJson = new JSONObject();
            resultJson.put("success", true);

            String token = userManager.getToken(username);

            Cookie cookie = new Cookie(
                    "token",
                    token,
                    "/",
                    2592000,
                    true,
                    0,
                    false,
                    null,
                    null,
                    SameSite.STRICT
            );
            context.cookie(cookie);
            Webserver.returnJson(context, resultJson);
        } else {
            LoggingSaver.addLogEntry(LoggingType.LOGIN_FAIL, username + " (" + context.ip() + ")");
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
        }
    }

    public static void getCurrent(Context context, UserManager userManager) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        String token = context.cookie("token");
        String username = userManager.getUsername(token);
        if (!username.isEmpty()) {
            returnJsonObject.put("username", username);
        } else {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void getPermissions(Context context, UserManager userManager) {
        String token = context.cookie("token");
        String username = userManager.getUsername(token);
        JSONObject returnJson = new JSONObject();

        if (username.isEmpty()) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        ArrayList<String> permissions = userManager.getPermissions(username, true);
        JSONArray jsonArrayPermissions = new JSONArray();
        for (String permission : permissions) {
            jsonArrayPermissions.put(permission.toLowerCase());
        }
        returnJson.put("success", true);
        returnJson.put("permissions", jsonArrayPermissions);
        Webserver.returnJson(context, returnJson);
    }

    public static void logout(Context context, UserManager userManager) {
        JSONObject returnJson = new JSONObject();

        String token = context.cookie("token");
        String username = userManager.getUsername(token);

        if (username.isEmpty()) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        userManager.logout(username);
        returnJson.put("success", true);
        context.cookie("token", "", 0);
        Webserver.returnJson(context, returnJson);
    }

    public static void changePassword(Context context, UserManager userManager) {
        String username = context.formParam("username");
        String passwordBase64 = context.formParam("password");
        String newPasswordBase64 = context.formParam("new-password");
        if (username == null || passwordBase64 == null || newPasswordBase64 == null) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }
        String password = new String(Base64.getUrlDecoder().decode(passwordBase64));
        String passwordHash = CryptManager.getHash(password);

        int result = userManager.authenticateUser(username, passwordHash);
        if (result == UserManager.SUCCESS) {
            String newPassword = new String(Base64.getUrlDecoder().decode(newPasswordBase64));
            String newPasswordHash = CryptManager.getHash(newPassword);
            userManager.setPassword(username, newPasswordHash);

            JSONObject resultJson = new JSONObject();
            resultJson.put("success", true);
            Webserver.returnJson(context, resultJson);
        } else {
            LoggingSaver.addLogEntry(LoggingType.LOGIN_FAIL, username);
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
        }

    }
}
