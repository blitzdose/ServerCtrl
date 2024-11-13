package de.blitzdose.serverctrl.standalone.impl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractBackupApi;
import de.blitzdose.serverctrl.standalone.impl.backup.BackupRunnable;
import org.bukkit.Bukkit;
import org.bukkit.World;

import java.io.File;
import java.util.*;

public class BackupApiImpl extends AbstractBackupApi {
    @Override
    public List<String> getWorldPaths(String system, List<UUID> worlds) {
        return worlds.stream().map(Bukkit::getWorld).filter(Objects::nonNull).map(World::getWorldFolder).map(File::getPath).toList();
    }

    @Override
    public Map<String, UUID> getWorlds(String system) {
        Map<String, UUID> worlds = new HashMap<>();
        for (World world : Bukkit.getWorlds()) {
            worlds.put(world.getName(), world.getUID());
        }
        return worlds;
    }

    @Override
    public void startBackup(String system, int id, List<String> paths) {
        Thread backupThread = new Thread(new BackupRunnable(paths, id));
        backupThread.start();
    }
}
