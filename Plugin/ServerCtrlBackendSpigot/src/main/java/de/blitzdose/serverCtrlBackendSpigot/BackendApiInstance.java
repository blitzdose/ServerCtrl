package de.blitzdose.serverCtrlBackendSpigot;

import org.bukkit.Bukkit;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.plugin.Plugin;

import java.util.List;

public class BackendApiInstance extends de.blitzdose.api.BackendApiInstance {

    private final Plugin plugin;

    public BackendApiInstance(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public void sendMessage(String message) {
        Bukkit.getConsoleSender().sendMessage(message);
    }

    @Override
    public List<String> configGetStringList(String key) {
        return plugin.getConfig().getStringList(key);
    }

    @Override
    public String configGetString(String key) {
        return plugin.getConfig().getString(key);
    }

    @Override
    public int configGetInt(String key) {
        return plugin.getConfig().getInt(key);
    }

    @Override
    public boolean configGetBoolean(String key) {
        return plugin.getConfig().getBoolean(key);
    }

    @Override
    public boolean configContains(String key) {
        return plugin.getConfig().contains(key);
    }

    @Override
    public void configUpdate(String key, Object value) {
        plugin.getConfig().set(key, value);
        plugin.saveConfig();
    }

    @Override
    public List<String> configGetKeys(String key) {
        ConfigurationSection section = plugin.getConfig().getConfigurationSection(key);
        if (section == null) return List.of();
        return section.getKeys(false).stream().toList();
    }

    @Override
    public String getKeystorePath() {
        return "plugins/ServerCtrlBackend/cert.jks";
    }

    @Override
    public String getRootCAPath() {
        return "plugins/ServerCtrlBackend/RootCA.cer";
    }

    @Override
    public String getLogPath() {
        return "plugins/ServerCtrlBackend/log/main.log";
    }

    @Override
    public String getDataDBPath() {
        return "plugins/ServerCtrlBackend/data.db";
    }
}
