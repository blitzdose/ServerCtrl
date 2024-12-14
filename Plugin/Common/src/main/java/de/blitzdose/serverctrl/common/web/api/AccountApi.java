package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.crypt.CryptManager;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.Role;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Set;
import java.util.regex.Pattern;

public class AccountApi {

    public static void getAccounts(Context context) {
        JSONObject returnJson = new JSONObject();
        Set<String> users = Webserver.userManager.getUsers();
        if (users == null) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }
        returnJson.put("accounts", users);
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }

    public static void getAllPermissions(Context context) {
        JSONObject returnJson = new JSONObject();

        String[] roles = Arrays.stream(Role.values()).map(Enum::name).filter(s -> !s.equals("ANYONE")).toArray(String[]::new);

        returnJson.put("permissions", roles);
        returnJson.put("success", true);

        Webserver.returnJson(context, returnJson);
    }

    public static void setPermissions(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        String username = requestJson.getString("user");
        JSONArray permissions = requestJson.getJSONArray("permissions");
        for (int i=0; i<permissions.length(); i++) {
            JSONObject permission = permissions.getJSONObject(i);
            try {
                Role role = Role.valueOf(permission.getString("name").toUpperCase());
                Webserver.userManager.setRole(username, role, permission.getBoolean("state"));
            } catch (IllegalArgumentException ignored) { }
        }
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }

    public static void getPermissions(Context context) {
        try {
            String username = context.queryParam("username");
            ArrayList<String> permissions = Webserver.userManager.getPermissions(username, false);
            JSONObject returnJson = new JSONObject();
            returnJson.put("permissions", permissions);
            returnJson.put("success", true);
            Webserver.returnJson(context, returnJson);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void resetPassword(Context context) {
        try {
            JSONObject returnJson = new JSONObject();

            JSONObject requestJson = new JSONObject(context.body());
            String username = requestJson.getString("username");
            String password = requestJson.getString("new-password");
            password = new String(Base64.getDecoder().decode(password));

            String passwordHash = CryptManager.getLegacyHash(password);

            if (passwordHash == null) {
                returnJson.put("success", false);
                Webserver.returnJson(context, returnJson);
            }

            Webserver.userManager.setPassword(username, passwordHash);

            returnJson.put("success", true);
            Webserver.returnJson(context, returnJson);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void delete(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        String username = requestJson.getString("username");
        Webserver.userManager.logout(username);
        Webserver.userManager.deleteUser(username);

        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }

    public static void create(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String username = requestJson.getString("username");
        String password = new String(Base64.getDecoder().decode(requestJson.getString("new-password")));

        if (username == null || username.isBlank() || password.isBlank() || !Pattern.matches("^([a-zA-Z0-9]+)$", username)) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        boolean success = Webserver.userManager.createUser(username, password);

        returnJson.put("success", success);
        if (!success) {
            returnJson.put("error", 2);
        }
        Webserver.returnJson(context, returnJson);
    }
}

