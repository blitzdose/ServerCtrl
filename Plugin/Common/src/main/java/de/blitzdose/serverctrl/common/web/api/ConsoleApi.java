package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.Role;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.util.Base64;

public class ConsoleApi {

    public static void getLog(Context context) {
        context.pathParam("system");

        JSONObject returnJson = new JSONObject();
        String log = Webserver.abstractConsoleApi.getConsoleLog(context.pathParam("system"));
        if (log != null) {
            //log = log.substring(log.length()-5000);
            returnJson.put("log", log);
            returnJson.put("success", true);

            Webserver.returnJson(context, returnJson);
        } else {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
        }

    }

    public static void command(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        String commandJson = context.body().trim();
        JSONObject commandJsonObject = new JSONObject(commandJson);
        if (commandJsonObject.get("command") != null) {
            returnJsonObject.put("success", true);
            String command = new String(Base64.getUrlDecoder().decode(commandJsonObject.get("command").toString()));
            command = command.trim();
            if (command.startsWith("msr") || command.contains(":msr")) {
                returnJsonObject.put("success", false);
                Webserver.returnJson(context, returnJsonObject);
                return;
            }
            if (!hasPermission(command, context.cookie("token"))) {
                returnJsonObject.put("success", false);
                Webserver.returnJson(context, returnJsonObject);
                return;
            }
            try {
                Webserver.abstractConsoleApi.sendCommand(context.pathParam("system"), command);
                Webserver.loggingSaver.addLogEntry(LoggingType.COMMAND_SEND, context, command);
            } catch (Exception e) {
                e.printStackTrace();
                returnJsonObject.put("success", false);
            }

            Webserver.returnJson(context, returnJsonObject);
        }
    }

    private static boolean hasPermission(String command, String token) {
        UserManager userManager = Webserver.userManager;
        if (userManager.hasPermission(Role.CONSOLE, token)) {
            return true;
        }
        if (command.startsWith("kick ")) {
            return userManager.hasPermission(Role.KICK, token);
        } else if (command.startsWith("ban ")) {
            return userManager.hasPermission(Role.BAN, token);
        } else if (command.startsWith("op ") || command.startsWith("deop ")) {
            return userManager.hasPermission(Role.OP, token);
        } else {
            return false;
        }
    }

}
