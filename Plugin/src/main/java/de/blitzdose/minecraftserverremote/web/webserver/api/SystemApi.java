package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.systemdata.SystemDataLogger;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

public class SystemApi {
    public static void getData(Context context) {
        JSONObject systemDataJsonObject = new JSONObject();
        if (SystemDataLogger.historicSystemData.length()<=0) {
            systemDataJsonObject.put("success", false);
            Webserver.returnJson(context, systemDataJsonObject);
            return;
        }

        systemDataJsonObject = SystemDataLogger.historicSystemData.getJSONObject(SystemDataLogger.historicSystemData.length() - 1);
        systemDataJsonObject.put("success", true);

        Webserver.returnJson(context, systemDataJsonObject);
    }

    public static void getHistoricData(Context context) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        returnJson.put("data", SystemDataLogger.historicSystemData);

        Webserver.returnJson(context, returnJson);
    }
}
