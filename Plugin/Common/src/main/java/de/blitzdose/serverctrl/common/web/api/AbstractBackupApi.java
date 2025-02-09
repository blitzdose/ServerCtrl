package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.Backup.Backup;
import kotlin.Pair;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public abstract class AbstractBackupApi {
    public abstract List<String> getWorldPaths(String system, List<UUID> worlds);
    public abstract Map<String, UUID> getWorlds(String system);
    public abstract void startBackup(String system, int id, List<String> paths);
    public abstract List<Backup.BackupState> getFinishedBackups(String system);
    public abstract boolean delete(String system, String name);
    public abstract Pair<Long, BufferedInputStream> getAsStream(String system, String name) throws FileNotFoundException;
}
