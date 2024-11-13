package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.util.*;

public class BackupApi {

    public static final List<Integer> backupThreads = new ArrayList<>();

    public static class Worlds {

        public static void startCreateBackup(Context context) {
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

    private static void createBackup(Context context, List<String> paths) {
        JSONObject jsonObject = new JSONObject(context.body());

        int id;
        Random random = new Random();
        do {
            id = random.nextInt(0, Integer.MAX_VALUE);
        } while (backupThreads.contains(id));

        Webserver.abstractBackupApi.startBackup(context.pathParam("system"), id, paths);
        backupThreads.add(id);

        jsonObject.put("success", true);
        jsonObject.put("backupId", id);
        Webserver.returnJson(context, jsonObject);
    }
}
