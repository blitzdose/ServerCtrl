package de.blitzdose.serverctrl.standalone.impl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractSystemApi;
import de.blitzdose.serverctrl.standalone.impl.SystemDataLogger;
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
