package de.blitzdose.serverCtrlBackendSpigot;

import de.blitzdose.logger.ConsoleLogger;
import de.blitzdose.webserver.WebServer;
import org.bukkit.plugin.java.JavaPlugin;

public final class ServerCtrlBackend extends JavaPlugin {

    private WebServer webServer;

    @Override
    public void onEnable() {
        getConfig().options().copyDefaults(true);
        saveConfig();

        BackendApiInstance backendApiInstance = new BackendApiInstance(ServerCtrlBackend.this);

        new Thread(() -> {
            webServer = new WebServer(
                    WebserverConfigParser.parseFromYAML(getConfig().getConfigurationSection("Webserver")),
                    new ConsoleLogger("ServerCtrlBackend", backendApiInstance),
                    backendApiInstance
            );

            webServer.start();
        }).start();
    }

    @Override
    public void onDisable() {
        if (webServer != null) {
            webServer.stop();
        }
    }
}
