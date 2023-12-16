package de.blitzdose.minecraftserverremote.logging;

import org.bukkit.Bukkit;

public class Logger {
    public static void log(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §a" + message);
    }

    public static void error(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §fError: §4" + message);
    }

    public static void info(String message) {
        Bukkit.getConsoleSender().sendMessage("§6[ServerCtrl] §fInfo: §3" + message);
    }
}
