package de.blitzdose.serverctrl.embedded.api;

import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.SystemDataLogger;

public class SystemApiImpl {

    private final SystemDataLogger systemDataLogger;

    public SystemApiImpl(SystemDataLogger systemDataLogger) {
        this.systemDataLogger = systemDataLogger;
    }

    public WebsocketResponse getHistoricSystemData() {
        return new WebsocketResponse(
                true,
                systemDataLogger.historicSystemData
        );
    }
}
