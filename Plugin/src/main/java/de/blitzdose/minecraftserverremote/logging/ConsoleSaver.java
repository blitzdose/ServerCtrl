package de.blitzdose.minecraftserverremote.logging;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class ConsoleSaver implements Runnable {

    ConsoleFilter filter;

    public ConsoleSaver() {
        Logger logger = (org.apache.logging.log4j.core.Logger) LogManager.getRootLogger();
        filter = new ConsoleFilter();
        logger.addFilter(filter);
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

    @Override
    public void run() {
        StringBuilder log = new StringBuilder();

        try {
            new File("plugins/ServerCtrl/log/").mkdirs();
            if (new File("plugins/ServerCtrl/log/console.log").exists()) {
                OutputStream outputStream = new FileOutputStream("plugins/ServerCtrl/log/console.log");
                OutputStreamWriter outputStreamWriter = new OutputStreamWriter(outputStream, StandardCharsets.UTF_8);

                ArrayList<String> messages = filter.messages;

                for (String message : messages) {
                    message = message.replace("\u007F", "!_/");

                    message = message.replaceAll("\u001B\\[0;30;22m", "!_/0");
                    message = message.replaceAll("\u001B\\[0;34;22m", "!_/1");
                    message = message.replaceAll("\u001B\\[0;32;22m", "!_/2");
                    message = message.replaceAll("\u001B\\[0;36;22m", "!_/3");
                    message = message.replaceAll("\u001B\\[0;31;22m", "!_/4");
                    message = message.replaceAll("\u001B\\[0;35;22m", "!_/5");
                    message = message.replaceAll("\u001B\\[0;33;22m", "!_/6");
                    message = message.replaceAll("\u001B\\[0;37;22m", "!_/7");
                    message = message.replaceAll("\u001B\\[0;30;1m", "!_/8");
                    message = message.replaceAll("\u001B\\[0;34;1m", "!_/9");
                    message = message.replaceAll("\u001B\\[0;32;1m", "!_/a");
                    message = message.replaceAll("\u001B\\[0;36;1m", "!_/b");
                    message = message.replaceAll("\u001B\\[0;31;1m", "!_/c");
                    message = message.replaceAll("\u001B\\[0;35;1m", "!_/d");
                    message = message.replaceAll("\u001B\\[0;33;1m", "!_/e");
                    message = message.replaceAll("\u001B\\[0;37;1m", "!_/f");

                    message = message.replaceAll("\u001B\\[m", "");
                    message = message.replaceAll("§", "!_/");

                    log.append(message).append("\n");
                }

                outputStreamWriter.write(log.toString());
                outputStreamWriter.flush();
                outputStreamWriter.close();
            } else {
                new File("plugins/ServerCtrl/log/console.log").createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
