package de.blitzdose.api;

import java.util.List;

abstract public class BackendApiInstance {
    abstract public void sendMessage(String message);

    abstract public List<String> configGetStringList(String key);
    abstract public String configGetString(String key);
    abstract public int configGetInt(String key);
    abstract public boolean configGetBoolean(String key);
    abstract public boolean configContains(String key);
    abstract public void configUpdate(String key, Object value);
    abstract public List<String> configGetKeys(String key);

    public abstract String getKeystorePath();
    public abstract String getRootCAPath();

    public abstract String getLogPath();

    public abstract String getDataDBPath();
}
