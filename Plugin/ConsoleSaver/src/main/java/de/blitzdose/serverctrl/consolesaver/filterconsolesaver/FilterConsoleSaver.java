package de.blitzdose.serverctrl.consolesaver.filterconsolesaver;

import de.blitzdose.serverctrl.consolesaver.AbstractConsoleSaver;
import de.blitzdose.serverctrl.consolesaver.appenderconsolesaver.ConsoleAppender;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class FilterConsoleSaver extends AbstractConsoleSaver {

    Logger logger;
    ConsoleAppender consoleAppender;
    String path;

    public FilterConsoleSaver(String path, Logger logger, Level minLevel) {
        this.path = path;
        this.logger = logger;

        File logFile = new File(path);
        if (!logExists()) {
            try {
                new File(path.substring(0, path.lastIndexOf("/"))).mkdirs();
                logFile.createNewFile();
            } catch (IOException ignored) { }
        }

        this.logger.setFilter(record -> {
            if (record.getLevel().intValue() < minLevel.intValue()) return true;
            Handler handler = this.logger.getHandlers()[0];
            try {
                FileWriter fileWriter = new FileWriter(logFile, StandardCharsets.UTF_8, true);
                String message = handler.getFormatter().format(record);
                message = message.replaceAll("§", "!_/");
                fileWriter.append(message);
                fileWriter.close();
            } catch (IOException ignored) { }
            return true;
        });
    }

    @Override
    public String getLogFile() {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(path, StandardCharsets.UTF_8));
            String log = reader.lines().collect(Collectors.joining("\n"));
            reader.close();
            return log;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    @Override
    public boolean logExists() {
        File file = new File(path);
        return file.exists();
    }

    @Override
    public void clearLogFile() {
        try {
            logger.setFilter(record -> true);
            BufferedWriter writer = new BufferedWriter(new FileWriter(path));
            writer.write("");
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
