package de.blitzdose.serverctrl.embedded.api;

import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.consolesaver.AbstractConsoleSaver;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;

import java.util.concurrent.ExecutionException;

public class ConsoleApiImpl {

    private final ApiInstance instance;
    private final AbstractConsoleSaver consoleSaver;

    public ConsoleApiImpl(ApiInstance instance, AbstractConsoleSaver consoleSaver) {
        this.instance = instance;
        this.consoleSaver = consoleSaver;
    }

    public WebsocketResponse sendCommand(String command) {
        if (command.equals("restartmsr")) {
            instance.restartServer();
        }

        try {
            instance.sendCommand(command);
            return new WebsocketResponse(true, null);
        } catch (ExecutionException | InterruptedException e) {
            return new WebsocketResponse(false, null);
        }

    }

    public WebsocketResponse getLog() {
        if (consoleSaver.logExists()) {
            return new WebsocketResponse(
                    true,
                    consoleSaver.getLogFile()
            );
        } else {
            return new WebsocketResponse(
                    false,
                    null
            );
        }
    }
}
