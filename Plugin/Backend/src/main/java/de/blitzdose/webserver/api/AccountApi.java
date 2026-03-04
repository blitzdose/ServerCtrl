package de.blitzdose.webserver.api;

import de.blitzdose.webserver.WebServer;
import de.blitzdose.webserver.auth.Role;
import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.auth.shiro.UserManager;
import io.javalin.http.Context;
import org.eclipse.jetty.http.HttpStatus;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.*;

public class AccountApi {

    public static void getAccounts(Context context) {
        List<User> users = WebServer.userManager.getUsers();
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", users.stream().map(User::getUsername).toList()));
    }

    public static void getAllPermissions(Context context) {
        String[] roles = Arrays.stream(Role.values()).map(Enum::name).toArray(String[]::new);
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", roles));
    }

    public static void setPermissions(Context context) {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String username = data.getString("username");
        User user = WebServer.userManager.getUserByUsername(username);
        List<Role> roles = new ArrayList<>();

        JSONObject systems = data.getJSONObject("systems");
        for (String system : systems.keySet()) {
            JSONArray permissionsArray = systems.getJSONArray(system);
            for (int i=0; i<permissionsArray.length(); i++) {
                roles.add(Role.valueOf(permissionsArray.getString(i).toUpperCase()));
            }
            WebServer.userManager.setRoles(user, system, roles);
        }

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void getPermissions(Context context) {
        String username = context.queryParam("username");
        if (username == null) {
            WebServer.returnFailedJson(context);
            return;
        }
        User user = WebServer.userManager.getUserByUsername(username);

        Map<String, List<Role>>  roles = user.getRoleSets();
        WebServer.returnSuccessfulJson(context,
                new JSONObject().put("data",
                        new JSONObject()
                                .put("superAdmin", user.isSuperAdmin())
                                .put("permissions", new JSONObject(roles))
                )
        );
    }

    public static void resetPassword(Context context) {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String username = data.getString("username");
        String passwordBase64 = data.getString("newPassword");

        String password = new String(Base64.getDecoder().decode(passwordBase64));
        User user = WebServer.userManager.getUserByUsername(username);

        WebServer.userManager.changePassword(user, password);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void delete(Context context) {
        String username = WebServer.getData(context, String.class);

        User user = WebServer.userManager.getUserByUsername(username);
        WebServer.userManager.deleteUser(user);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void create(Context context) {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String username = data.getString("username");
        String passwordBase64 = data.getString("newPassword");
        String password = new String(Base64.getDecoder().decode(passwordBase64));

        try {
            WebServer.userManager.createUser(username, password);
        } catch (UserManager.UserManagerException.UserExistsException e) {
            context.status(HttpStatus.CONFLICT_409);
            context.result();
        } catch (UserManager.UserManagerException.InvalidUsernameException e) {
            context.status(HttpStatus.BAD_REQUEST_400);
            context.result();
        }

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void setSuperAdmin(Context context) {
        JSONObject jsonObject = WebServer.getData(context, JSONObject.class);
        String username = jsonObject.getString("username");
        boolean isSuperAdmin = jsonObject.getBoolean("superAdmin");
        User user = WebServer.userManager.getUserByUsername(username);
        WebServer.userManager.setSuperAdmin(user, isSuperAdmin);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }
}

