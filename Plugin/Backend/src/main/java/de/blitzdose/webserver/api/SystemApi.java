package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

public class SystemApi {
    public static void getData(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException, WebsocketException.RequestNotSuccessfulException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetHistoricSystemData, null));

        JSONArray historicSystemData = response.data(JSONArray.class);

        if (historicSystemData.length()<=0) {
            WebServer.returnFailedJson(context);
            return;
        }

        JSONObject systemDataJsonObject = historicSystemData.getJSONObject(historicSystemData.length() - 1);
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", systemDataJsonObject));
    }

    public static void getHistoricData(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetHistoricSystemData, null));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONArray.class)));
    }
}
