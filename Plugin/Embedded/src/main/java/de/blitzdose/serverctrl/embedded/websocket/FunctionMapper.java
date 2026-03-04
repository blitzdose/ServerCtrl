package de.blitzdose.serverctrl.embedded.websocket;

import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.Implementations;
import org.json.JSONObject;

public class FunctionMapper {

    private final Implementations implementations;

    public FunctionMapper(Implementations implementations) {
        this.implementations = implementations;
    }

    WebsocketResponse mapFunction(WebsocketRequest request) {

        WebsocketResponse response = switch (request.method()) {
            case GetHistoricSystemData -> implementations.getSystemApi().getHistoricSystemData();

            case GetIcon -> implementations.getServerApi().getServerIcon();
            case GetName -> implementations.getServerApi().getServerName();
            case SetName -> implementations.getServerApi().setServerName(request.data(String.class));
            case GetServerData -> implementations.getServerApi().getServerData();
            case GetServerSettings -> implementations.getServerApi().getServerProperties();
            case SetServerSettings -> implementations.getServerApi().setServerProperties(request.data(JSONObject.class));
            case StopServer -> implementations.getServerApi().stopServer();
            case RestartServer -> implementations.getServerApi().restartServer();
            case ReloadServer -> implementations.getServerApi().reloadServer();


            case GetOnline -> implementations.getPlayerApi().getOnline(request.data(JSONObject.class));
            case GetPlayerCount -> implementations.getPlayerApi().getPlayerCount();

            case GetConsoleLog -> implementations.getConsoleApi().getLog();
            case SendCommand -> implementations.getConsoleApi().sendCommand(request.data(String.class));

            case ListFiles -> implementations.getFileApi().listFiles(request.data(JSONObject.class));
            case CountFiles -> implementations.getFileApi().countFiles(request.data(String.class));
            case DownloadFile -> implementations.getFileApi().downloadFile(request.data(JSONObject.class));
            case DeleteFileFolder -> implementations.getFileApi().deleteFile(request.data(String.class));
            case CreateFile -> implementations.getFileApi().createFile(request.data(String.class));
            case CreateFolder -> implementations.getFileApi().createDir(request.data(String.class));
            case RenameFileFolder -> implementations.getFileApi().renameFile(request.data(JSONObject.class));
            case ExtractFile -> implementations.getFileApi().extractFile(request.data(String.class));
            case DownloadMultipleFiles -> implementations.getFileApi().downloadMultipleFiles(request.data(JSONObject.class));
            case UploadFile -> implementations.getFileApi().uploadFile(request.data(JSONObject.class));
            case DeleteMultipleFileFolder -> implementations.getFileApi().deleteMultiple(request.dataAsArray(String.class));

            case ListWorlds -> implementations.getBackupApi().listWorlds();
            case CreateWorldsBackup -> implementations.getBackupApi().startWorldsBackup(request.dataAsArray(String.class));
            case CreateFullBackup -> implementations.getBackupApi().startFullBackup();
            case ListBackups -> implementations.getBackupApi().listBackups();
            case DeleteBackup -> implementations.getBackupApi().delete(request.data(String.class));
        };

        response.setIdentifier(request.identifier());
        return response;
    }
}
