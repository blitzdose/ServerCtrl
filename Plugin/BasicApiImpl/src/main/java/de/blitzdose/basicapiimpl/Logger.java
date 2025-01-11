package de.blitzdose.basicapiimpl;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.logging.LoggingType;

import java.util.List;

public class Logger implements de.blitzdose.serverctrl.common.logging.Logger {

    private final ApiInstance instance;

    public Logger(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public void log(String message) {
        instance.sendMessage("§6[ServerCtrl] §a" + message);
    }

    @Override
    public void error(String message) {
        instance.sendMessage("§6[ServerCtrl] §fError: §4" + message);
    }

    @Override
    public void info(String message) {
        instance.sendMessage("§6[ServerCtrl] §fInfo: §3" + message);
    }

    @Override
    public boolean isWebLoggingDisabledForType(LoggingType type) {
        List<String> loggingTypes = instance.configGetStringList("Logging-types");
        return !loggingTypes.contains(type.name());
    }

}
