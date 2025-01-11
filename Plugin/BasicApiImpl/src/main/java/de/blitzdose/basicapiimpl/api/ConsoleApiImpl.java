package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractConsoleApi;
import de.blitzdose.serverctrl.consolesaver.AbstractConsoleSaver;

import java.util.concurrent.ExecutionException;

public class ConsoleApiImpl extends AbstractConsoleApi {

    private final ApiInstance instance;
    private final AbstractConsoleSaver consoleSaver;

    public ConsoleApiImpl(ApiInstance instance, AbstractConsoleSaver consoleSaver) {
        this.instance = instance;
        this.consoleSaver = consoleSaver;
    }

    @Override
    public void sendCommand(String system, String command) throws ExecutionException, InterruptedException {
        if (command.equals("restartmsr")) {
            instance.restartServer();
        }

        instance.sendCommand(command);
    }

    @Override
    public String getConsoleLog(String system) {
        if (consoleSaver.logExists()) {
            return consoleSaver.getLogFile();
        } else {
            return null;
        }
    }
}
