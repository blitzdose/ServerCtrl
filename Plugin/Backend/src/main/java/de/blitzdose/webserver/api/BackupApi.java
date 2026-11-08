package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import de.blitzdose.webserver.files.FileTransferManager;
import de.blitzdose.webserver.logging.SecurityLogType;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

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

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DeleteBackup,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void download(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String system = context.queryParam("system");
        String path = context.queryParam("path");

        WebsocketResponse pathResponse = WebsocketHandler.tunnelThroughWebsocket(
                system,
                new WebsocketRequest(
                        RequestMethod.GetBackupDownloadPath,
                        path
                )
        );

        String filePath = pathResponse.data(String.class);

        FileTransferManager transferManager = WebServer.fileTransferManager;
        FileTransferManager.Transfer transfer = transferManager.initNewTransfer(context);

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(system,
                new WebsocketRequest(
                        RequestMethod.DownloadFile,
                        new JSONObject().put("path", filePath).put("transferID", transfer.getID())
                ),
                false
        );

        if (!response.success()) {
            transfer.cancel();
            WebServer.return400(context);
            return;
        }

        WebServer.securityLog(SecurityLogType.DOWNLOADED_FILES, context, "Downloaded file " + filePath);

        transfer.setTimeout(30, TimeUnit.SECONDS);
        context.future(transfer::registerHandler);
    }
}
