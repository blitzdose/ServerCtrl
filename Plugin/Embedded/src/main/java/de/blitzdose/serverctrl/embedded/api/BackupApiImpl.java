package de.blitzdose.serverctrl.embedded.api;

import com.google.gson.Gson;
import de.blitzdose.serverctrl.common.backup.Backup;
import de.blitzdose.serverctrl.common.web.parser.PathParser;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.backup.BackupRunnable;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

public class BackupApiImpl {

    private final ApiInstance instance;

    public BackupApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    public WebsocketResponse listWorlds() {
        JSONArray jsonArray = new JSONArray();
        for (Map.Entry<String, UUID> entry : instance.getWorlds().entrySet()) {
            jsonArray.put(new JSONObject().put("name", entry.getKey()).put("uuid", entry.getValue().toString()));
        }
        return new WebsocketResponse(true, jsonArray);
    }

    public void startBackup(Backup.Type type, List<String> paths) {
        Backup.BackupState backupState;
        do {
            backupState = new Backup.BackupState(type);
        } while (Backup.backupThreads.containsKey(backupState.id));

        Thread backupThread = new Thread(new BackupRunnable(instance.getPluginFolder(), paths, backupState));
        backupThread.start();

        Backup.backupThreads.put(backupState.id, backupState);
    }

    public List<Backup.BackupState> getFinishedBackups() {
        File backupFolder = instance.getPluginFolder().resolve("./Backups").normalize().toFile();
        if (!backupFolder.exists() || backupFolder.listFiles() == null) return List.of();
        return Arrays.stream(Objects.requireNonNull(backupFolder.listFiles()))
                .filter(file -> file.getName().endsWith(".tar.gz"))
                .map(Backup.BackupState::parseFromFile)
                .filter(Objects::nonNull).toList();
    }

    public WebsocketResponse delete(String name) {
        Path path = PathParser.parsePath(instance.getPluginFolder().resolve("./Backups"), name);
        if (path == null) {
            return new WebsocketResponse(false, null);
        }
        File backupFile = path.toFile();
        if (!backupFile.exists()) {
            Backup.backupThreads.remove(Integer.parseInt(name.split("_")[0]));
            return new WebsocketResponse(true, null);
        }
        boolean success = backupFile.delete();
        if (success) {
            Backup.backupThreads.remove(Integer.parseInt(name.split("_")[0]));
        }
        return new WebsocketResponse(success, null);
    }

    public WebsocketResponse startWorldsBackup(String[] data) {
        List<String> worldPaths = instance.getWorldPaths(Arrays.stream(data).map(UUID::fromString).toList());
        startBackup(Backup.Type.WORLD, worldPaths);

        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse startFullBackup() {
        List<String> path = new ArrayList<>();
        path.add(Paths.get(".").toString());

        startBackup(Backup.Type.FULL, path);
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse listBackups() {
        JSONObject data = new JSONObject();
        Gson gson = new Gson();

        for (Backup.BackupState backupState : getFinishedBackups()) {
            data.put(backupState.fileName, new JSONObject(gson.toJson(backupState, Backup.BackupState.class)));
        }

        for (Backup.BackupState backupState: Backup.backupThreads.values()) {
            data.put(backupState.fileName, new JSONObject(gson.toJson(backupState, Backup.BackupState.class)));
        }

        return new WebsocketResponse(true, data.isEmpty() ? new JSONArray() : data.toJSONArray(data.names()));
    }

    public WebsocketResponse getBackupDownloadPath(String name) {
        Path path = PathParser.parsePath(instance.getPluginFolder().resolve("./Backups"), name);
        if (path == null) {
            return new WebsocketResponse(false, null);
        }
        return new WebsocketResponse(true, "/" + PathParser.parsePath("").toAbsolutePath().relativize(path).toString().replace("\\", "/"));
    }
}
