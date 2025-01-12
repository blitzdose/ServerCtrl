package de.blitzdose.basicapiimpl.instance;

import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;
import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;

import java.util.*;
import java.util.concurrent.ExecutionException;

public abstract class ApiInstance {
    abstract public void sendMessage(String message);

    abstract public List<String> configGetStringList(String key);
    abstract public String configGetString(String key);
    abstract public int configGetInt(String key);
    abstract public boolean configGetBoolean(String key);
    abstract public boolean configContains(String key);
    abstract public void configUpdate(String key, Object value);

    public abstract void shutdownServer();
    public abstract void reloadServer();
    abstract public void restartServer();

    abstract public void sendCommand(String command) throws ExecutionException, InterruptedException;

    abstract public int getOnlinePlayerCount();
    abstract public List<AbstractPlayerApi.Player> getOnlinePlayers();

    abstract public Set<String> getUsers();

    public abstract AbstractServerApi.ServerData getServerData();
    public abstract Properties getServerProperties();
    public abstract boolean setServerProperties(Properties properties);

    public abstract List<String> getWorldPaths(List<UUID> worlds);
    public abstract Map<String, UUID> getWorlds();
}
