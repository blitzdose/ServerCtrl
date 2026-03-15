package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.parser.Pagination;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

public class PlayerApi {

    public static void getOnline(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        Pagination pagination = Pagination.parse(context.queryParamMap());

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("limit", pagination.limit());
        jsonObject.put("position", pagination.position());

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetOnline, jsonObject));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONArray.class)));
    }

    public static void countPlayers(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetPlayerCount, null));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(Integer.class)));
    }
}
