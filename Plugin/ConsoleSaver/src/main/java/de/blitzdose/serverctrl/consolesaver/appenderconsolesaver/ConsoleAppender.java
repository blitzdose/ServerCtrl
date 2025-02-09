package de.blitzdose.serverctrl.consolesaver.appenderconsolesaver;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.Layout;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.AbstractAppender;
import org.jetbrains.annotations.NotNull;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ConsoleAppender extends AbstractAppender {

    private final SimpleDateFormat formatter = new SimpleDateFormat("hh:mm:ss");

    private final String path;
    private final boolean includeLoggerName;

    protected ConsoleAppender(String name, Filter filter, Layout<? extends Serializable> layout, String path, boolean includeLoggerName) {
        super(name, filter, layout);
        this.includeLoggerName = includeLoggerName;
        this.path = path;
    }

    @Override
    public void append(LogEvent logEvent) {
        String message = logEvent.getMessage().getFormattedMessage();
        String loggerName = "";
        if (!logEvent.getLoggerName().isBlank() && includeLoggerName) {
            loggerName = "[" + logEvent.getLoggerName() + "] ";
        }
        String colorWhole = "";
        if (logEvent.getLevel() == Level.ERROR) {
            colorWhole = "§4";
        }
        message = colorWhole + "[" + formatter.format(new Date(logEvent.getTimeMillis())) + " " + logEvent.getLevel() + "]§f " + loggerName + message;
        //messages.add(message);

        try {
            new File(path.substring(0, path.lastIndexOf("/"))).mkdirs();
            if (!new File(path).exists()) {
                new File(path).createNewFile();
            }

            FileWriter fileWriter = new FileWriter(path, StandardCharsets.UTF_8, true);
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

            message = message.replace("\u007F", "!_/");

            message = replaceANSI1(message);
            message = replaceANSI2(message);
            message = replaceANSI3(message);

            message = message.replaceAll("\u001B\\[m", "");
            message = message.replaceAll("\u001B\\[0m", "");
            message = message.replaceAll("§", "!_/");

            bufferedWriter.append(message);
            bufferedWriter.newLine();
            bufferedWriter.flush();
            bufferedWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @NotNull
    private String replaceANSI3(String message) {
        message = message.replaceAll("\u001B\\[38;2;0;0;0m", "!_/0");
        message = message.replaceAll("\u001B\\[38;2;0;0;170m", "!_/1");
        message = message.replaceAll("\u001B\\[38;2;0;170;0m", "!_/2");
        message = message.replaceAll("\u001B\\[38;2;0;170;170m", "!_/3");
        message = message.replaceAll("\u001B\\[38;2;170;0;0m", "!_/4");
        message = message.replaceAll("\u001B\\[38;2;170;0;170m", "!_/5");
        message = message.replaceAll("\u001B\\[38;2;255;170;0m", "!_/6");
        message = message.replaceAll("\u001B\\[38;2;170;170;170m", "!_/7");
        message = message.replaceAll("\u001B\\[38;2;85;85;85m", "!_/8");
        message = message.replaceAll("\u001B\\[38;2;85;85;255m", "!_/9");
        message = message.replaceAll("\u001B\\[38;2;85;255;85m", "!_/a");
        message = message.replaceAll("\u001B\\[38;2;85;255;255m", "!_/b");
        message = message.replaceAll("\u001B\\[38;2;255;85;85m", "!_/c");
        message = message.replaceAll("\u001B\\[38;2;255;85;255m", "!_/d");
        message = message.replaceAll("\u001B\\[38;2;255;255;85m", "!_/e");
        message = message.replaceAll("\u001B\\[38;2;255;255;255m", "!_/f");
        return message;
    }

    @NotNull
    private String replaceANSI2(String message) {
        message = message.replaceAll("\u001B\\[30m", "!_/0");
        message = message.replaceAll("\u001B\\[34m", "!_/1");
        message = message.replaceAll("\u001B\\[32m", "!_/2");
        message = message.replaceAll("\u001B\\[36m", "!_/3");
        message = message.replaceAll("\u001B\\[31m", "!_/4");
        message = message.replaceAll("\u001B\\[35m", "!_/5");
        message = message.replaceAll("\u001B\\[33m", "!_/6");
        message = message.replaceAll("\u001B\\[37m", "!_/7");
        message = message.replaceAll("\u001B\\[90m", "!_/8");
        message = message.replaceAll("\u001B\\[94m", "!_/9");
        message = message.replaceAll("\u001B\\[92m", "!_/a");
        message = message.replaceAll("\u001B\\[96m", "!_/b");
        message = message.replaceAll("\u001B\\[91m", "!_/c");
        message = message.replaceAll("\u001B\\[95m", "!_/d");
        message = message.replaceAll("\u001B\\[93m", "!_/e");
        message = message.replaceAll("\u001B\\[97m", "!_/f");
        return message;
    }

    @NotNull
    private String replaceANSI1(String message) {
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
        return message;
    }
}
