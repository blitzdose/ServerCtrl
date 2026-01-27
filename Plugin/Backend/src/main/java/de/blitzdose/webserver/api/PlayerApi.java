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
        Pagination pagination = Pagination.parse(WebServer.getData(context, JSONObject.class));

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetOnline, null));

        JSONArray data = response.data(JSONArray.class);
        JSONArray returnData = new JSONArray();

        for (int i = pagination.position(); i<(pagination.limit() == -1 ? data.length() : pagination.limit() + pagination.position()); i++) {
            if (i >= data.length()) {
                break;
            }

            returnData.put(data.get(i));
        }

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", returnData));
    }

    public static void countPlayers(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetPlayerCount, null));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(Integer.class)));
    }
}
