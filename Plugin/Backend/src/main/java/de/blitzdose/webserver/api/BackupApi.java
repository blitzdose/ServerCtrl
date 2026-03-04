package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.parser.PathParser;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.UUID;

public class BackupApi {

    public static class Worlds {

        public static void listWorlds(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
            WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                    context.queryParam("system"),
                    new WebsocketRequest(
                            RequestMethod.ListWorlds,
                            null
                    )
            );

            WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONArray.class)));
        }

        public static void startCreateWorldsBackup(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
            JSONArray data = WebServer.getData(context, JSONArray.class);
            JSONArray worlds = new JSONArray(data.toList().stream().map(o -> UUID.fromString(o.toString())).map(UUID::toString).toArray(String[]::new));

            WebsocketHandler.tunnelThroughWebsocket(
                    context.queryParam("system"),
                    new WebsocketRequest(
                            RequestMethod.CreateWorldsBackup,
                            worlds
                    )
            );

            WebServer.returnSuccessfulJson(context, new JSONObject());
        }
    }

    public static void list(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.ListBackups,
                        null
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONArray.class)));
    }

    public static void startCreateFullBackup(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.CreateFullBackup,
                        null
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void delete(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = PathParser.parsePath(path, true);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DeleteBackup,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void download(Context context) {
        String system = context.queryParam("system");
        String path = context.queryParam("path");
        path = PathParser.parsePath(path, true);
        context.redirect("/api/files/download?system=" + system + "&path=/plugins/ServerCtrl/Backups/" + path);
    }
}
