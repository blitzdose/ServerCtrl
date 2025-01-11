package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import io.javalin.http.Context;
import io.javalin.http.Cookie;
import io.javalin.http.SameSite;
import org.eclipse.jetty.http.HttpStatus;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Base64;

public class UserApi {
    public static void login(Context context, UserManager userManager) {
        String username = context.formParam("username");
        String passwordBase64 = context.formParam("password");
        String code = context.formParam("code");
        String needsAppPassword = context.formParam("needsAppPassword");
        String password = null;
        if (passwordBase64 != null) {
            password = new String(Base64.getUrlDecoder().decode(passwordBase64.trim()));
        }
        if (username == null || password == null) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }

        int result = userManager.authenticateUser(username, password, code);



        if (result == UserManager.SUCCESS) {
            Webserver.loggingSaver.addLogEntry(LoggingType.LOGIN_SUCCESS, username + " (" + context.ip() + ")");

            JSONObject resultJson = new JSONObject();
            if (needsAppPassword != null && needsAppPassword.equals("true")) {
                String appPassword = userManager.createAppPassword(username);
                resultJson.put("appPassword", appPassword);
            }
            resultJson.put("success", true);

            String token = userManager.getToken(username);

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
            Webserver.returnJson(context, resultJson);
        } else if (result == UserManager.WRONG_TOTP) {
            context.status(HttpStatus.PAYMENT_REQUIRED_402);
            context.result();
        } else {
            Webserver.loggingSaver.addLogEntry(LoggingType.LOGIN_FAIL, username + " (" + context.ip() + ")");
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
        String username = userManager.getUsername(context.cookie("token"));
        String passwordBase64 = context.formParam("password");
        String newPasswordBase64 = context.formParam("new-password");
        String code = context.formParam("code");
        if (username.isEmpty() || passwordBase64 == null || newPasswordBase64 == null) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }
        String password = new String(Base64.getUrlDecoder().decode(passwordBase64));

        int result = userManager.authenticateUser(username, password, code);
        if (result == UserManager.SUCCESS) {
            boolean success = userManager.changePassword(username, password);

            JSONObject resultJson = new JSONObject();
            resultJson.put("success", success);
            Webserver.returnJson(context, resultJson);
        } else if (result == UserManager.WRONG_TOTP) {
            context.status(HttpStatus.PAYMENT_REQUIRED_402);
            context.result();
        } else {
            Webserver.loggingSaver.addLogEntry(LoggingType.LOGIN_FAIL, username);
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
        }

    }

    public static void initTOTP(Context context, UserManager userManager) {
        JSONObject resultJson = new JSONObject();

        String passwordBase64 = context.formParam("password");
        String password = null;
        if (passwordBase64 != null) {
            password = new String(Base64.getUrlDecoder().decode(passwordBase64.trim()));
        }

        if (password == null || password.isEmpty()) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }

        String token = context.cookie("token");
        String username = userManager.getUsername(token);

        int result = userManager.authenticateUser(username, password, null);

        if (result == UserManager.SUCCESS) {
            String secret = userManager.initTOTP(username);
            if (secret != null) {
                resultJson.put("success", true);
                resultJson.put("secret", secret);
                Webserver.returnJson(context, resultJson);
            } else {
                resultJson.put("success", false);
                Webserver.returnJson(context, resultJson);
            }
        } else if (result == UserManager.WRONG_TOTP) {
            context.status(HttpStatus.PAYMENT_REQUIRED_402);
            context.result();
        } else {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
        }
    }

    public static void verifyTOTP(Context context, UserManager userManager) {
        String token = context.cookie("token");
        String username = userManager.getUsername(token);
        String code = context.formParam("code");

        boolean success;
        try {
            success = userManager.verifyTOTP(username, code);
        } catch (IOException | NoSuchAlgorithmException | InvalidKeyException e) {
            JSONObject resultJson = new JSONObject();
            resultJson.put("success", false);
            Webserver.returnJson(context, resultJson);
            return;
        }

        JSONObject resultJson = new JSONObject();
        resultJson.put("success", success);
        Webserver.returnJson(context, resultJson);
    }

    public static void removeTOTP(Context context, UserManager userManager) {
        String token = context.cookie("token");
        String username = userManager.getUsername(token);
        String code = context.formParam("code");
        String passwordBase64 = context.formParam("password");
        String password = null;
        if (passwordBase64 != null) {
            password = new String(Base64.getUrlDecoder().decode(passwordBase64.trim()));
        }

        if (password == null || password.isEmpty()) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
            return;
        }

        int result = userManager.authenticateUser(username, password, code);
        if (result == UserManager.WRONG_TOTP) {
            context.status(HttpStatus.PAYMENT_REQUIRED_402);
            context.result();
        } else if (result == UserManager.WRONG_PASSWORD_OR_USERNAME) {
            context.status(HttpStatus.UNAUTHORIZED_401);
            context.result();
        } else if (result == UserManager.SUCCESS){
            boolean success = userManager.removeTOTP(username, code);
            JSONObject resultJson = new JSONObject();
            resultJson.put("success", success);
            Webserver.returnJson(context, resultJson);
        }
    }

    public static void hasTOTP(Context context, UserManager userManager) {
        String token = context.cookie("token");
        String username = userManager.getUsername(token);
        boolean hasTOTP = userManager.hasTOTP(username);
        JSONObject resultJson = new JSONObject();
        resultJson.put("success", true);
        resultJson.put("hastotp", hasTOTP);
        Webserver.returnJson(context, resultJson);
    }
}
