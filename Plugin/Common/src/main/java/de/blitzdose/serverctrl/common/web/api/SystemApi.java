package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

public class SystemApi {
    public static void getData(Context context) {
        JSONObject systemDataJsonObject = new JSONObject();
        JSONArray historicSystemData = Webserver.abstractSystemApi.getHistoricSystemData(context.pathParam("system"));
        if (historicSystemData.length()<=0) {
            systemDataJsonObject.put("success", false);
            Webserver.returnJson(context, systemDataJsonObject);
            return;
        }

        systemDataJsonObject = historicSystemData.getJSONObject(historicSystemData.length() - 1);
        systemDataJsonObject.put("success", true);

        Webserver.returnJson(context, systemDataJsonObject);
    }

    public static void getHistoricData(Context context) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        returnJson.put("data", Webserver.abstractSystemApi.getHistoricSystemData(context.pathParam("system")));

        Webserver.returnJson(context, returnJson);
    }
}
