package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.Backup.Backup;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.parser.PathParser;
import io.javalin.http.Context;
import io.javalin.json.JavalinGson;
import kotlin.Pair;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class BackupApi {

    public static class Worlds {

        public static void startCreateWorldsBackup(Context context) {
            JSONObject jsonObject = new JSONObject(context.body());
            List<UUID> worlds = jsonObject.getJSONArray("worlds").toList().stream()
                    .map(o -> UUID.fromString(o.toString())).toList();
            List<String> worldPaths = Webserver.abstractBackupApi.getWorldPaths(context.pathParam("system"), worlds);

            createBackup(context, worldPaths);
        }

        public static void listWorlds(Context context) {
            Map<String, UUID> worlds = Webserver.abstractBackupApi.getWorlds(context.pathParam("system"));

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("success", true);
            jsonObject.put("worlds", worlds);

            Webserver.returnJson(context, jsonObject);
        }
    }

    public static void startCreateFullBackup(Context context) {
        List<String> path = new ArrayList<>();
        path.add(Paths.get(".").toString());
        createBackup(context, path);
    }

    private static void createBackup(Context context, List<String> paths) {
        Backup.BackupState backupState;
        do {
            backupState = new Backup.BackupState();
        } while (Backup.backupThreads.containsKey(backupState.id));

        Webserver.abstractBackupApi.startBackup(context.pathParam("system"), backupState.id, paths);
        Backup.backupThreads.put(backupState.id, backupState);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("success", true);
        jsonObject.put("backupId", backupState.id);
        Webserver.returnJson(context, jsonObject);
    }

    public static void list(Context context) {
        JSONObject jsonObject = new JSONObject();
        JSONObject backupsObject = new JSONObject();
        JavalinGson gson = new JavalinGson();

        for (Backup.BackupState backupState : Webserver.abstractBackupApi.getFinishedBackups(context.pathParam("system"))) {
            backupsObject.put(backupState.id.toString(), new JSONObject(gson.toJsonString(backupState, Backup.BackupState.class)));
        }

        for (Backup.BackupState backupState: Backup.backupThreads.values()) {
            backupsObject.put(backupState.id.toString(), new JSONObject(gson.toJsonString(backupState, Backup.BackupState.class)));
        }

        jsonObject.put("backups", backupsObject);
        jsonObject.put("success", true);
        Webserver.returnJson(context, jsonObject);
    }

    public static void delete(Context context) {
        JSONObject jsonObject = new JSONObject(context.body());
        JSONObject returnJson = new JSONObject();

        if (jsonObject.has("name")) {
            String name = jsonObject.getString("name");
            name = PathParser.parsePath(name, true);
            boolean success = Webserver.abstractBackupApi.delete(context.pathParam("system"), name);
            if (success) {
                Backup.backupThreads.remove(Integer.parseInt(name.split("_")[0]));
            }
            returnJson.put("success", success);
            Webserver.returnJson(context, returnJson);
        } else {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
        }
    }

    public static void download(Context context) {
        String name = context.queryParam("name");
        if (name == null) {
            Webserver.return404(context);
        }
        name = PathParser.parsePath(name, true);

        try {
            Pair<Long, BufferedInputStream> fileStream = Webserver.abstractBackupApi.getAsStream(context.pathParam("system"), name);
            Webserver.returnFile(context, name, fileStream.component1(), fileStream.component2());
        } catch (FileNotFoundException e) {
            Webserver.return404(context);
        }
    }
}
