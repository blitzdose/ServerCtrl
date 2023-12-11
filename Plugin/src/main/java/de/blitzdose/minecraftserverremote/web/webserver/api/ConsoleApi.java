package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.logging.ConsoleSaver;
import de.blitzdose.minecraftserverremote.logging.LoggingSaver;
import de.blitzdose.minecraftserverremote.logging.LoggingType;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import de.blitzdose.minecraftserverremote.web.webserver.auth.Role;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.http.Context;
import org.bukkit.Bukkit;
import org.json.JSONObject;

import java.io.File;
import java.util.Base64;
import java.util.concurrent.ExecutionException;

public class ConsoleApi {

    public static void getLog(Context context) {
        JSONObject returnJson = new JSONObject();
        File logFile = new File("plugins/ServerCtrl/log/console.log");
        if (logFile.exists()) {
            try {
                String log = ConsoleSaver.getLogFile();
                //log = log.substring(log.length()-5000);
                returnJson.put("log", log);
                returnJson.put("success", true);

                Webserver.returnJson(context, returnJson);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
            String command = new String(Base64.getDecoder().decode(commandJsonObject.get("command").toString()));
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
                sendCommand(command);
                LoggingSaver.addLogEntry(LoggingType.COMMAND_SEND, context, command);
            } catch (Exception e) {
                e.printStackTrace();
                returnJsonObject.put("success", false);
            }

            Webserver.returnJson(context, returnJsonObject);
        }
    }

    private static boolean hasPermission(String command, String token) {
        UserManager userManager = new UserManager();
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

    private static void sendCommand(String command) throws ExecutionException, InterruptedException {
        if (command.equals("restartmsr")) {
            Bukkit.spigot().restart();
        }

        Bukkit.getScheduler().callSyncMethod(
                ServerCtrl.getPlugin(), () -> Bukkit.dispatchCommand( Bukkit.getServer().getConsoleSender(), command )
        ).get();
    }


}
