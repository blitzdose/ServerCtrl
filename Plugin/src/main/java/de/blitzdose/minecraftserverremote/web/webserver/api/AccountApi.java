package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.crypt.CryptManager;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import de.blitzdose.minecraftserverremote.web.webserver.auth.Role;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.http.Context;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.configuration.file.FileConfiguration;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.regex.Pattern;

public class AccountApi {

    public static void getAccounts(Context context) {
        JSONObject returnJson = new JSONObject();
        FileConfiguration configuration = ServerCtrl.getPlugin().getConfig();
        ConfigurationSection users = configuration.getConfigurationSection("Webserver.users");
        if (users == null) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }
        returnJson.put("accounts", users.getKeys(false));
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
        UserManager userManager = new UserManager();
        for (int i=0; i<permissions.length(); i++) {
            JSONObject permission = permissions.getJSONObject(i);
            try {
                Role role = Role.valueOf(permission.getString("name").toUpperCase());
                userManager.setRole(username, role, permission.getBoolean("state"));
            } catch (IllegalArgumentException ignored) { }
        }
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }

    public static void getPermissions(Context context) {
        try {
            String username = context.queryParam("username");
            ArrayList<String> permissions = new UserManager().getPermissions(username, false);
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

            String passwordHash = CryptManager.getHash(password);

            if (passwordHash == null) {
                returnJson.put("success", false);
                Webserver.returnJson(context, returnJson);
            }

            new UserManager().setPassword(username, passwordHash);

            returnJson.put("success", true);
            Webserver.returnJson(context, returnJson);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void delete(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        String username = requestJson.getString("username");
        new UserManager().logout(username);
        ServerCtrl.getPlugin().getConfig().set("Webserver.users." + username, null);
        ServerCtrl.getPlugin().getConfig().set("Webserver.permissions." + username, null);
        ServerCtrl.getPlugin().saveConfig();

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

        boolean success = new UserManager().createUser(username, password);

        returnJson.put("success", success);
        if (!success) {
            returnJson.put("error", 2);
        }
        Webserver.returnJson(context, returnJson);
    }
}

