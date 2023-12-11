package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.logging.LoggingSaver;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;

public class LogApi {
    public static void getLog(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        int limit = -1;
        if (requestJson.has("limit")) {
            limit = requestJson.getInt("limit");
        }

        int position = 0;
        if (requestJson.has("position")) {
            position = requestJson.getInt("position");
        }

        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);

        try {
            File logFile = new File("plugins/ServerCtrl/log/main.log");
            if (logFile.exists()) {
                String log = LoggingSaver.getLog(limit, position);

                returnJsonObject.put("log", log);
                Webserver.returnJson(context, returnJsonObject);
            } else {
                throw new IOException("File doesnt exist");
            }
        } catch (IOException e) {
            returnJsonObject.put("success", false);
            Webserver.returnJson(context, returnJsonObject);
        }
    }

    public static void countLogs(Context context) {
        long count = LoggingSaver.getLogCount();
        JSONObject returnJson = new JSONObject();
        returnJson.put("count", count);
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
