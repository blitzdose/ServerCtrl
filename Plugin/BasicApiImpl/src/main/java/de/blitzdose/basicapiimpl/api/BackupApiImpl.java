package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.backup.BackupRunnable;
import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.Backup.Backup;
import de.blitzdose.serverctrl.common.web.api.AbstractBackupApi;
import kotlin.Pair;
import org.apache.commons.lang3.math.NumberUtils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.*;

public class BackupApiImpl extends AbstractBackupApi {

    private final ApiInstance instance;

    public BackupApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public List<String> getWorldPaths(String system, List<UUID> worlds) {
        return instance.getWorldPaths(worlds);
    }

    @Override
    public Map<String, UUID> getWorlds(String system) {
        return instance.getWorlds();
    }

    @Override
    public void startBackup(String system, int id, List<String> paths) {
        Thread backupThread = new Thread(new BackupRunnable(paths, id));
        backupThread.start();
    }

    @Override
    public List<Backup.BackupState> getFinishedBackups(String system) {
        File backupFolder = new File("plugins/ServerCtrl/Backups");
        if (!backupFolder.exists() || backupFolder.listFiles() == null) return List.of();
        return Arrays.stream(Objects.requireNonNull(backupFolder.listFiles()))
                .filter(file -> file.getName().endsWith(".tar.gz"))
                .map(file -> new Pair<>(file, file.getName().split("_")[0]))
                .filter(pair -> NumberUtils.isDigits(pair.component2()))
                .map(pair -> new Pair<>(pair.component1(), Integer.parseInt(pair.component2())))
                .map(pair -> new Backup.BackupState(pair.component2(), 1.0f, Backup.State.FINISHED, pair.component1().getName(), pair.component1().length())).toList();
    }

    @Override
    public boolean delete(String system, String name) {
        File backupFile = new File("plugins/ServerCtrl/Backups/" + name);
        return backupFile.delete();
    }

    @Override
    public Pair<Long, BufferedInputStream> getAsStream(String system, String name) throws FileNotFoundException {
        File file = new File("plugins/ServerCtrl/Backups/" + name).getAbsoluteFile();
        long size = file.length();
        return new Pair<>(size, new BufferedInputStream(new FileInputStream(file)));
    }
}
