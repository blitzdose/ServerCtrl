package de.blitzdose.minecraftserverremote.logging;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.http.Context;
import org.bukkit.configuration.file.FileConfiguration;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class LoggingSaver {

    public static void addLogEntry(LoggingType type, String message) {
        if (loggingDisabled(type)) {
            return;
        }
        try {
            File file = new File("plugins/ServerCtrl/log/main.log");
            if (!file.exists()) {
                new File("plugins/ServerCtrl/log").mkdirs();
                file.createNewFile();
            }

            FileWriter writer = new FileWriter(file, true);
            writer.append("[").append(getTime()).append("] ").append(type.getTag()).append(" ").append(message).append("\n");
            writer.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static boolean loggingDisabled(LoggingType type) {
        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        List<String> loggingTypes = config.getStringList("Logging-types");
        return !loggingTypes.contains(type.name());
    }

    public static void addLogEntry(LoggingType type, Context context, String message) {
        String username = new UserManager().getUsername(context.cookie("token"));
        addLogEntry(type, "[" + username + "] " + message);
    }

    public static String getLog(int limit, int position) {
        File file = new File("plugins/ServerCtrl/log/main.log");
        if (file.exists()) {
            try {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                List<String> lines = reader.lines().collect(Collectors.toList());
                List<String> newLines = new ArrayList<>();
                for (int i=lines.size()-1; i>=0; i--) {
                    newLines.add(lines.get(i));
                }
                return newLines.stream().skip(position).limit(limit).collect(Collectors.joining("\n"));
            } catch (IOException ignored) { }
        }
        return "";
    }

    public static long getLogCount() {
        File file = new File("plugins/ServerCtrl/log/main.log");
        if (file.exists()) {
            try {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                return reader.lines().count();
            } catch (IOException ignored) {
            }
        }
        return -1;
    }

    private static String getTime() {
        DateFormat formatter = new SimpleDateFormat("dd.MM.yy HH:mm:ss");
        return formatter.format(new Date());
    }
}
