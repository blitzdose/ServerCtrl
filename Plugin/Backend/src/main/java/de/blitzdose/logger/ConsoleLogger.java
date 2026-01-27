package de.blitzdose.logger;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.serverctrl.common.logging.Logger;

public class ConsoleLogger implements Logger {

    private final String name;
    private final BackendApiInstance apiInstance;

    public ConsoleLogger(String name, BackendApiInstance apiInstance) {
        this.name = name;
        this.apiInstance = apiInstance;
    }

    @Override
    public void log(String message) {
        apiInstance.sendMessage("§6[" + name + "] §a" + message);
    }

    @Override
    public void error(String message) {
        apiInstance.sendMessage("§6[" + name + "] §fError: §4" + message);
    }

    @Override
    public void info(String message) {
        apiInstance.sendMessage("§6[" + name + "] §fInfo: §3" + message);
    }
}
