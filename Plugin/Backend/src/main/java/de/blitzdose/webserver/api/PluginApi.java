package de.blitzdose.webserver.api;

import de.blitzdose.apiimpl.BackendPluginApiImpl;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONObject;

public class PluginApi {
    public static void getSettings(Context context) {
        BackendPluginApiImpl pluginApi = new BackendPluginApiImpl(WebServer.backendApiInstance);
        WebsocketResponse response = pluginApi.getPluginSettings();

        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("data", response.data(JSONObject.class));

        WebServer.returnSuccessfulJson(context, jsonObject);
    }

    public static void setSettings(Context context) {
        JSONObject data = WebServer.getData(context, JSONObject.class);

        BackendPluginApiImpl pluginApi = new BackendPluginApiImpl(WebServer.backendApiInstance);
        WebsocketResponse response = pluginApi.setPluginSettings(data);

        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void setCertificate(Context context) {
        JSONObject data = WebServer.getData(context, JSONObject.class);

        BackendPluginApiImpl pluginApi = new BackendPluginApiImpl(WebServer.backendApiInstance);
        WebsocketResponse response = pluginApi.setCertificate(data);

        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void generateCertificate(Context context) {
        String data = WebServer.getData(context, String.class);

        BackendPluginApiImpl pluginApi = new BackendPluginApiImpl(WebServer.backendApiInstance);
        WebsocketResponse response = pluginApi.generateCertificate(data);

        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }
}
