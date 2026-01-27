package de.blitzdose.webserver.api;

import de.blitzdose.apiimpl.BackendFileApiImpl;
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

import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import static de.blitzdose.serverctrl.common.web.parser.PathParser.parsePath;

public class FilesApi {

    public static void listFiles(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        data.put("path", parsePath(data.getString("path"), false));

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(RequestMethod.ListFiles, data)
        );

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(JSONArray.class)));
    }

    public static void countFiles(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = parsePath(path, false);

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(RequestMethod.CountFiles, path)
        );

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(Integer.class)));
    }

    public static void downloadFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = parsePath(context.queryParam("path"), true);

        FileTransferManager transferManager = WebServer.fileTransferManager;
        FileTransferManager.Transfer transfer = transferManager.initNewTransfer(context);

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DownloadFile,
                        new JSONObject().put("path", path).put("transferID", transfer.getID())
                ),
                false
        );

        if (!response.success()) {
            transfer.cancel();
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.securityLog(SecurityLogType.DOWNLOADED_FILES, context, "Downloaded file " + path);

        transfer.setTimeout(30, TimeUnit.SECONDS);
        context.future(transfer::registerHandler);
    }

    public static void uploadFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        FileTransferManager transferManager = WebServer.fileTransferManager;
        FileTransferManager.Transfer transfer = transferManager.initNewTransfer(context);

        String path = parsePath(context.queryParam("path"), true);

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.UploadFile,
                        new JSONObject().put("path", path).put("transferID", transfer.getID())
                ),
                false
        );

        if (!response.success()) {
            transfer.cancel();
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.securityLog(SecurityLogType.UPLOADED_FILES, context, "Uploaded file " + path);

        context.future(transfer::registerHandler);
    }

    public static void extractFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = parsePath(path, true);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.ExtractFile,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void deleteFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = parsePath(path, true);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DeleteFileFolder,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void createFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = parsePath(path, true);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.CreateFile,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void createDir(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String path = WebServer.getData(context, String.class);
        path = parsePath(path, false);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.CreateFolder,
                        path
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void renameFile(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        JSONObject data = WebServer.getData(context, JSONObject.class);
        String path = parsePath(data.getString("path"), true);
        String newPath = parsePath(data.getString("newPath"), true);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.RenameFileFolder,
                        new JSONObject()
                                .put("path", path)
                                .put("newPath", newPath)
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void downloadMultiple(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        JSONArray data = new JSONArray(Objects.requireNonNull(context.queryParam("data")));
        List<String> paths = data.toList().stream().map(o -> (String) o).map(s -> parsePath(s, true)).toList();

        FileTransferManager transferManager = WebServer.fileTransferManager;
        FileTransferManager.Transfer transfer = transferManager.initNewTransfer(context);

        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DownloadMultipleFiles,
                        new JSONObject().put("paths", paths).put("transferID", transfer.getID())
                ),
                false
        );

        if (!response.success()) {
            transfer.cancel();
            WebServer.returnFailedJson(context);
            return;
        }

        context.future(transfer::registerHandler);
    }

    public static void deleteMultiple(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        JSONArray data = WebServer.getData(context, JSONArray.class);
        String[] paths = data.toList().stream().map(o -> (String) o).map(s -> parsePath(s, true)).toArray(String[]::new);

        WebsocketHandler.tunnelThroughWebsocket(
                context.queryParam("system"),
                new WebsocketRequest(
                        RequestMethod.DeleteMultipleFileFolder,
                        paths
                )
        );

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    public static void getEditableFiles(Context context) {
        BackendFileApiImpl fileApi = new BackendFileApiImpl(WebServer.backendApiInstance);
        List<String> editableFiles = fileApi.getEditableFiles();

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", editableFiles));
    }

    public static void setEditableFiles(Context context) {
        BackendFileApiImpl fileApi = new BackendFileApiImpl(WebServer.backendApiInstance);

        JSONArray data = WebServer.getData(context, JSONArray.class);
        List<String> editableFiles = data.toList().stream().map(o -> (String) o).toList();

        fileApi.setEditableFiles(editableFiles);

        WebServer.returnSuccessfulJson(context, new JSONObject());
    }
}
