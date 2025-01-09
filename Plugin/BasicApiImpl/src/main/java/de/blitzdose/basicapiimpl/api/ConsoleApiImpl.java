package de.blitzdose.basicapiimpl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractConsoleApi;
import de.blitzdose.serverctrl.consolesaver.ConsoleSaver;
import org.bukkit.Bukkit;
import org.bukkit.plugin.Plugin;

import java.util.concurrent.ExecutionException;

public class ConsoleApiImpl extends AbstractConsoleApi {

    private final Plugin plugin;
    private final ConsoleSaver consoleSaver;

    public ConsoleApiImpl(Plugin plugin, ConsoleSaver consoleSaver) {
        this.plugin = plugin;
        this.consoleSaver = consoleSaver;
    }

    @Override
    public void sendCommand(String system, String command) throws ExecutionException, InterruptedException {
        if (command.equals("restartmsr")) {
            Bukkit.spigot().restart();
        }

        Bukkit.getScheduler().callSyncMethod(plugin, () -> Bukkit.dispatchCommand( Bukkit.getServer().getConsoleSender(), command)).get();
    }

    @Override
    public String getConsoleLog(String system) {
        if (consoleSaver.logExists()) {
            return consoleSaver.getLogFile();
        } else {
            return null;
        }
    }
}
