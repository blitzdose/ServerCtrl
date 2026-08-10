package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.util.Base64;

public class ServerApi {

    public static void getIcon(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetIcon, null));

        if (response.data(String.class) != null) {
            String iconBase64 = response.data(String.class);
            byte[] serverIcon = Base64.getDecoder().decode(iconBase64);
            WebServer.returnImage(context, serverIcon);
        } else {
            context.redirect("/view/img/unknown_server.png");
        }
    }

    public static void getData(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetServerData, null));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONObject.class)));
    }

    public static void getSettings(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetServerSettings, null));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("data", response.data(JSONObject.class));

        WebServer.returnSuccessfulJson(context, jsonObject);
    }

    public static void setSettings(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        JSONObject data = WebServer.getData(context, JSONObject.class);

        WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.SetServerSettings, data));

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void stop(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebServer.returnSuccessfulJson(context, new JSONObject());
        WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.StopServer, null));
    }

    public static void restart(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebServer.returnSuccessfulJson(context, new JSONObject());
        WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.RestartServer, null));
    }

    public static void reload(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebServer.returnSuccessfulJson(context, new JSONObject());
        WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.ReloadServer, null));
    }
}
