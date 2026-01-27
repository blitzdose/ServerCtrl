package de.blitzdose.serverctrl.embedded.api;

import com.google.gson.Gson;
import de.blitzdose.serverctrl.common.backup.Backup;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.backup.BackupRunnable;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;
import kotlin.Pair;
import org.apache.commons.lang3.math.NumberUtils;
import org.json.JSONObject;

import java.io.File;
import java.nio.file.Paths;
import java.util.*;

public class BackupApiImpl {

    private final ApiInstance instance;

    public BackupApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    public WebsocketResponse listWorlds() {
        Map<String, UUID> worlds = instance.getWorlds();
        return new WebsocketResponse(true, new JSONObject(worlds));
    }

    public void startBackup(List<String> paths) {
        Backup.BackupState backupState;
        do {
            backupState = new Backup.BackupState();
        } while (Backup.backupThreads.containsKey(backupState.id));

        Thread backupThread = new Thread(new BackupRunnable(paths, backupState.id));
        backupThread.start();

        Backup.backupThreads.put(backupState.id, backupState);
    }

    public List<Backup.BackupState> getFinishedBackups() {
        File backupFolder = new File("plugins/ServerCtrl/Backups");
        if (!backupFolder.exists() || backupFolder.listFiles() == null) return List.of();
        return Arrays.stream(Objects.requireNonNull(backupFolder.listFiles()))
                .filter(file -> file.getName().endsWith(".tar.gz"))
                .map(file -> new Pair<>(file, file.getName().split("_")[0]))
                .filter(pair -> NumberUtils.isDigits(pair.component2()))
                .map(pair -> new Pair<>(pair.component1(), Integer.parseInt(pair.component2())))
                .map(pair -> new Backup.BackupState(pair.component2(), 1.0f, Backup.State.FINISHED, pair.component1().getName(), pair.component1().length())).toList();
    }

    public WebsocketResponse delete(String name) {
        File backupFile = new File("plugins/ServerCtrl/Backups/" + name);
        boolean success = backupFile.delete();
        if (success) {
            Backup.backupThreads.remove(Integer.parseInt(name.split("_")[0]));
        }
        return new WebsocketResponse(success, null);
    }

    public WebsocketResponse startWorldsBackup(String[] data) {
        List<String> worldPaths = instance.getWorldPaths(Arrays.stream(data).map(UUID::fromString).toList());
        startBackup(worldPaths);

        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse startFullBackup() {
        List<String> path = new ArrayList<>();
        path.add(Paths.get(".").toString());

        startBackup(path);
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse listBackups() {
        JSONObject data = new JSONObject();
        Gson gson = new Gson();

        for (Backup.BackupState backupState : getFinishedBackups()) {
            data.put(backupState.id.toString(), new JSONObject(gson.toJson(backupState, Backup.BackupState.class)));
        }

        for (Backup.BackupState backupState: Backup.backupThreads.values()) {
            data.put(backupState.id.toString(), new JSONObject(gson.toJson(backupState, Backup.BackupState.class)));
        }

        return new WebsocketResponse(true, data);
    }
}
