package de.blitzdose.basicapiimpl;

import de.blitzdose.serverctrl.common.logging.LoggingType;
import org.bukkit.Bukkit;
import org.bukkit.plugin.Plugin;

import java.util.List;

public class Logger implements de.blitzdose.serverctrl.common.logging.Logger {

    private final Plugin plugin;

    public Logger(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public void log(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §a" + message);
    }

    @Override
    public void error(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §fError: §4" + message);
    }

    @Override
    public void info(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §fInfo: §3" + message);
    }

    @Override
    public boolean isWebLoggingDisabledForType(LoggingType type) {
        List<String> loggingTypes = plugin.getConfig().getStringList("Logging-types");
        return !loggingTypes.contains(type.name());
    }


}
