package de.blitzdose.serverctrl.common.web.api;

import org.json.JSONArray;

public abstract class AbstractSystemApi {
    public abstract JSONArray getHistoricSystemData(String system);
}
