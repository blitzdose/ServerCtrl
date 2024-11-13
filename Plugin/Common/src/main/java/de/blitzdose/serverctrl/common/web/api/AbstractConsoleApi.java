package de.blitzdose.serverctrl.common.web.api;

import java.util.concurrent.ExecutionException;

public abstract class AbstractConsoleApi {

    public abstract void sendCommand(String system, String command) throws ExecutionException, InterruptedException;
    public abstract String getConsoleLog(String system);

}
