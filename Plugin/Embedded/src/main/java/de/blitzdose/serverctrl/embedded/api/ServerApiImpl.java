package de.blitzdose.serverctrl.embedded.api;

import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;
import de.blitzdose.serverctrl.embedded.models.ServerData;
import org.apache.commons.io.FileUtils;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.util.Base64;
import java.util.Properties;

public class ServerApiImpl {

    private final ApiInstance instance;

    public ServerApiImpl(ApiInstance instance) {
        this.instance = instance;
    }
    
    public WebsocketResponse getServerIcon() {
        byte[] icon;
        try {
            icon = FileUtils.readFileToByteArray(new File("server-icon.png"));
        } catch (IOException e) {
            icon = null;
        }

        if (icon == null) {
            return new WebsocketResponse(true, null);
        } else {
            return new WebsocketResponse(true, Base64.getEncoder().encodeToString(icon));
        }
    }
    
    public WebsocketResponse getServerName() {
        String serverName = instance.configGetString("Webserver.servername");
        if (serverName == null) {
            return new WebsocketResponse(false, null);
        }
        return new WebsocketResponse(true, serverName);
    }

    public WebsocketResponse setServerName(String data) {
        if (data == null || data.isEmpty()) {
            return new WebsocketResponse(false, null);
        }

        instance.configUpdate("Webserver.servername", data);

        return new WebsocketResponse(true, null);
    }
    
    public WebsocketResponse getServerData() {
        ServerData serverData = instance.getServerData();

        if (serverData == null) {
            return new WebsocketResponse(false, null);
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("motd", serverData.getMotd());
        jsonObject.put("port", serverData.getPort());
        jsonObject.put("version", serverData.getVersion());
        jsonObject.put("maxPlayers", serverData.getMaxPlayers());
        jsonObject.put("onlineMode", serverData.isOnlineMode());
        jsonObject.put("allowEnd", serverData.isAllowEnd());
        jsonObject.put("allowNether", serverData.isAllowNether());
        jsonObject.put("hasWhitelist", serverData.hasWhitelist());
        jsonObject.put("allowCommandBlock", serverData.isAllowCommandBlock());
        jsonObject.put("type", serverData.getType().toString());

        return new WebsocketResponse(true, jsonObject);
    }

    public WebsocketResponse getServerProperties() {
        Properties properties = instance.getServerProperties();

        if (properties == null) {
            return new WebsocketResponse(false, null);
        }

        JSONObject jsonObject = new JSONObject();

        for (Object keyObject : properties.keySet()) {
            String key = (String) keyObject;
            String value = properties.getProperty(key);
            jsonObject.put(key, value);
        }

        return new WebsocketResponse(true, jsonObject);
    }
    
    public WebsocketResponse setServerProperties(JSONObject data) {
        if (data == null) {
            return new WebsocketResponse(false, null);
        }

        Properties props = new Properties();
        for (String key : data.keySet()) {
            props.setProperty(key, data.getString(key));
        }

        boolean success = instance.setServerProperties(props);

        return new WebsocketResponse(success, null);
    }
    
    public WebsocketResponse stopServer() {
        instance.shutdownServer();
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse restartServer() {
        instance.restartServer();
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse reloadServer() {
        instance.reloadServer();
        return new WebsocketResponse(true, null);
    }
}
