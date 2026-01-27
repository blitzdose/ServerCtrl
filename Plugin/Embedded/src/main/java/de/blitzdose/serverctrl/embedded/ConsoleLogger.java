package de.blitzdose.serverctrl.embedded;

import de.blitzdose.serverctrl.embedded.instance.ApiInstance;

public class ConsoleLogger implements de.blitzdose.serverctrl.common.logging.Logger {

    private final ApiInstance instance;
    private final String loggerName;

    public ConsoleLogger(ApiInstance instance) {
        this.instance = instance;
        this.loggerName = "ServerCtrl";
    }

    public ConsoleLogger(String loggerName, ApiInstance instance) {
        this.instance = instance;
        this.loggerName = loggerName;
    }

    @Override
    public void log(String message) {
        instance.sendMessage("§6[" + loggerName + "] §a" + message);
    }

    @Override
    public void error(String message) {
        instance.sendMessage("§6[" + loggerName + "] §fError: §4" + message);
    }

    @Override
    public void info(String message) {
        instance.sendMessage("§6[" + loggerName + "] §fInfo: §3" + message);
    }
}
