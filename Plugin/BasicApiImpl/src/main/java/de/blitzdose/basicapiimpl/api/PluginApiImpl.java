package de.blitzdose.basicapiimpl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractPluginApi;
import org.bukkit.plugin.Plugin;

public class PluginApiImpl extends AbstractPluginApi {

    private final Plugin plugin;

    public PluginApiImpl(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public void setPort(int port) {
        plugin.getConfig().set("Webserver.port", port);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setHTTPS(boolean https) {
        plugin.getConfig().set("Webserver.https", https);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public int getPort() {
        return plugin.getConfig().getInt("Webserver.port");
    }

    @Override
    public boolean isHTTPS() {
        return plugin.getConfig().getBoolean("Webserver.https");
    }

    @Override
    public String getKeystorePath() {
        return "plugins/ServerCtrl/cert.jks";
    }

    @Override
    public String getRootCAPath() {
        return "plugins/ServerCtrl/RootCA.cer";
    }
}
