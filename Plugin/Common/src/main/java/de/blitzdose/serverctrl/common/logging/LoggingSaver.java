package de.blitzdose.serverctrl.common.logging;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public abstract class LoggingSaver {

    public abstract String getLogFilePath();

    public void addLogEntry(LoggingType type, String message) {
        if (loggingDisabled(type)) {
            return;
        }
        try {
            File file = new File(getLogFilePath());
            if (!file.exists()) {
                new File(getLogFilePath().substring(0, getLogFilePath().lastIndexOf("/"))).mkdirs();
                file.createNewFile();
            }

            FileWriter writer = new FileWriter(file, true);
            writer.append("[").append(getTime()).append("] ").append(type.getTag()).append(" ").append(message).append("\n");
            writer.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private boolean loggingDisabled(LoggingType type) {
        return Webserver.logger.isWebLoggingDisabledForType(type);
    }

    public void addLogEntry(LoggingType type, Context context, String message) {
        String username = Webserver.userManager.getUsername(context.cookie("token"));
        addLogEntry(type, "[" + username + "] " + message);
    }

    public String getLog(int limit, int position) {
        File file = new File(getLogFilePath());
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
        return null;
    }

    public long getLogCount() {
        File file = new File(getLogFilePath());
        if (file.exists()) {
            try {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                return reader.lines().count();
            } catch (IOException ignored) {
            }
        }
        return -1;
    }

    private String getTime() {
        DateFormat formatter = new SimpleDateFormat("dd.MM.yy HH:mm:ss");
        return formatter.format(new Date());
    }
}
