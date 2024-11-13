package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Properties;

public class ServerApi {

    public static void getIcon(Context context) {
        byte[] serverIcon = Webserver.abstractServerApi.getServerIcon(context.pathParam("system"));
        if (serverIcon != null) {
            Webserver.returnImage(context, serverIcon);
        } else {
            context.redirect("/view/img/unknown_server.png");
        }
    }

    public static void getName(Context context) {
        JSONObject returnJsonObject = new JSONObject();

        String serverName = Webserver.abstractServerApi.getServerName(context.pathParam("system"));

        if (serverName != null) {
            returnJsonObject.put("success", true);
            returnJsonObject.put("servername", serverName);
        } else {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void getData(Context context) {
        JSONObject serverDataJsonObject = new JSONObject();
        AbstractServerApi.ServerData serverData = Webserver.abstractServerApi.getServerData(context.pathParam("system"));

        serverDataJsonObject.put("motd", serverData.getMotd());
        serverDataJsonObject.put("port", serverData.getPort());
        serverDataJsonObject.put("version", serverData.getVersion());
        serverDataJsonObject.put("maxPlayers", serverData.getMaxPlayers());
        serverDataJsonObject.put("onlineMode", serverData.isOnlineMode());
        serverDataJsonObject.put("allowEnd", serverData.isAllowEnd());
        serverDataJsonObject.put("allowNether", serverData.isAllowNether());
        serverDataJsonObject.put("hasWhitelist", serverData.hasWhitelist());
        serverDataJsonObject.put("allowCommandBlock", serverData.isAllowCommandBlock());

        JSONObject returnObject = new JSONObject();
        returnObject.put("success", true);
        returnObject.put("data", serverDataJsonObject);

        Webserver.returnJson(context, returnObject);
    }

    public static void getSettings(Context context) throws IOException {
        JSONObject returnJsonObject = new JSONObject();

        Properties properties = Webserver.abstractServerApi.getServerProperties(context.pathParam("system"));

        if (properties == null) {
            returnJsonObject.put("success", false);
            Webserver.returnJson(context, returnJsonObject);
            return;
        }

        JSONObject data = new JSONObject();

        for (Object keyObject : properties.keySet()) {
            String key = (String) keyObject;
            String value = properties.getProperty(key);
            data.put(key, value);
        }

        returnJsonObject.put("success", true);
        returnJsonObject.put("data", data);

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setName(Context context) {
        JSONObject newServerName = new JSONObject(context.body());
        JSONObject returnJsonObject = new JSONObject();

        if (newServerName.has("servername")) {
            Webserver.abstractServerApi.setServerName(context.pathParam("system"), newServerName.getString("servername"));
            returnJsonObject.put("success", true);
        } else {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setSettings(Context context) {
        JSONObject returnJsonObject = new JSONObject();

        JSONObject data = new JSONObject(context.body());

        Properties props = new Properties();
        for (String key : data.keySet()) {
            props.setProperty(key, data.getString(key));
        }

        boolean success = Webserver.abstractServerApi.setServerProperties(context.pathParam("system"), props);

        returnJsonObject.put("success", success);
        Webserver.returnJson(context, returnJsonObject);
    }

    public static void stop(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Webserver.abstractServerApi.stopServer(context.pathParam("system"));
    }

    public static void restart(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Webserver.abstractServerApi.restartServer(context.pathParam("system"));
    }

    public static void reload(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Webserver.abstractServerApi.reloadServer(context.pathParam("system"));
    }
}
