package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

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

        String log = Webserver.loggingSaver.getLog(limit, position);
        if (log == null) {
            returnJsonObject.put("success", false);
            Webserver.returnJson(context, returnJsonObject);
        } else {
            returnJsonObject.put("log", log);
            Webserver.returnJson(context, returnJsonObject);
        }
    }

    public static void countLogs(Context context) {
        long count = Webserver.loggingSaver.getLogCount();
        JSONObject returnJson = new JSONObject();
        returnJson.put("count", count);
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
