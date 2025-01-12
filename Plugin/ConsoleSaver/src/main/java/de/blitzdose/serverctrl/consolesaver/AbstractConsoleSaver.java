package de.blitzdose.serverctrl.consolesaver;

public abstract class AbstractConsoleSaver {

    public abstract String getLogFile();
    public abstract boolean logExists();
    public abstract void clearLogFile();
}
