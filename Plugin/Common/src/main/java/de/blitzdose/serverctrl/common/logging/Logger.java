package de.blitzdose.serverctrl.common.logging;

public interface Logger {
    void log(String message);
    void error(String message);
    void info(String message);

    boolean isWebLoggingDisabledForType(LoggingType type);
}
