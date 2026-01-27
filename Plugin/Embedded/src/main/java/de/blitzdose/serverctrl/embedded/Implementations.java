package de.blitzdose.serverctrl.embedded;

import de.blitzdose.serverctrl.consolesaver.AbstractConsoleSaver;
import de.blitzdose.serverctrl.embedded.api.*;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;

public class Implementations {
    private final ApiInstance instance;
    private final AbstractConsoleSaver consoleSaver;
    private final SystemDataLogger systemDataLogger;

    public Implementations(ApiInstance instance, AbstractConsoleSaver consoleSaver, SystemDataLogger systemDataLogger) {
        this.instance = instance;
        this.consoleSaver = consoleSaver;
        this.systemDataLogger = systemDataLogger;
    }

    public SystemApiImpl getSystemApi() {
        return new SystemApiImpl(systemDataLogger);
    }

    public ServerApiImpl getServerApi() {
        return new ServerApiImpl(instance);
    }

    public PlayerApiImpl getPlayerApi() {
        return new PlayerApiImpl(instance);
    }

    public ConsoleApiImpl getConsoleApi() {
        return new ConsoleApiImpl(instance, consoleSaver);
    }

    public FileApiImpl getFileApi() {
        return new FileApiImpl(instance);
    }

    public BackupApiImpl getBackupApi() {
        return new BackupApiImpl(instance);
    }
}
