package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.SystemDataLogger;
import de.blitzdose.serverctrl.common.web.api.AbstractSystemApi;
import org.json.JSONArray;

public class SystemApiImpl extends AbstractSystemApi {

    private final SystemDataLogger systemDataLogger;

    public SystemApiImpl(SystemDataLogger systemDataLogger) {
        this.systemDataLogger = systemDataLogger;
    }

    @Override
    public JSONArray getHistoricSystemData(String system) {
        return systemDataLogger.historicSystemData;
    }
}
