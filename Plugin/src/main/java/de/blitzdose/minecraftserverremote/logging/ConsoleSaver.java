package de.blitzdose.minecraftserverremote.logging;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.layout.MessageLayout;

import java.io.*;
import java.util.stream.Collectors;

public class ConsoleSaver {

    Logger logger;
    ConsoleAppender consoleAppender;

    public ConsoleSaver() {
        logger = (org.apache.logging.log4j.core.Logger) LogManager.getRootLogger();
        consoleAppender = new ConsoleAppender("ServerCtrl", null, new MessageLayout());
        consoleAppender.start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (!consoleAppender.isStarted()) { }
                logger.addAppender(consoleAppender);
            }
        }).start();
    }

    public static String getLogFile() {
        try {
            BufferedReader reader = new BufferedReader(new FileReader("plugins/ServerCtrl/log/console.log"));
            String log = reader.lines().collect(Collectors.joining("\n"));
            reader.close();
            return log;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    public void clearLogFile() {
        try {
            logger.removeAppender(consoleAppender);
            BufferedWriter writer = new BufferedWriter(new FileWriter("plugins/ServerCtrl/log/console.log"));
            writer.write("");
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
