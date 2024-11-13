package de.blitzdose.serverctrl.consolesaver;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.layout.MessageLayout;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

public class ConsoleSaver {

    Logger logger;
    ConsoleAppender consoleAppender;
    String path;

    public ConsoleSaver(String path) {
        this.path = path;
        logger = (org.apache.logging.log4j.core.Logger) LogManager.getRootLogger();
        consoleAppender = new ConsoleAppender("ServerCtrl", null, new MessageLayout(), path);
        consoleAppender.start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (!consoleAppender.isStarted()) { }
                logger.addAppender(consoleAppender);
            }
        }).start();
    }

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

    public boolean logExists() {
        File file = new File(path);
        return file.exists();
    }

    public void clearLogFile() {
        try {
            logger.removeAppender(consoleAppender);
            BufferedWriter writer = new BufferedWriter(new FileWriter(path));
            writer.write("");
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
