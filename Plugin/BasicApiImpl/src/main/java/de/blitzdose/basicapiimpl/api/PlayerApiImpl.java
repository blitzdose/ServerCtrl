package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;

import java.util.List;

public class PlayerApiImpl extends AbstractPlayerApi {

    private final ApiInstance instance;

    public PlayerApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public int getPlayerCount(String system) {
        return instance.getOnlinePlayerCount();
    }

    @Override
    public List<Player> getOnlinePlayer(String system) {
        return instance.getOnlinePlayers();
    }
}
