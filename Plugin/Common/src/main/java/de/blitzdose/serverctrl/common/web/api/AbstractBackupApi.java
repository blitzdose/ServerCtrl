package de.blitzdose.serverctrl.common.web.api;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public abstract class AbstractBackupApi {
    public abstract List<String> getWorldPaths(String system, List<UUID> worlds);
    public abstract Map<String, UUID> getWorlds(String system);
    public abstract void startBackup(String system, int id, List<String> paths);
}
