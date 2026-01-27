package de.blitzdose.serverCtrlClient;

import de.blitzdose.serverctrl.consolesaver.appenderconsolesaver.AppenderConsoleSaver;
import de.blitzdose.serverctrl.embedded.ConsoleLogger;
import de.blitzdose.serverctrl.embedded.Implementations;
import de.blitzdose.serverctrl.embedded.SystemDataLogger;
import de.blitzdose.serverctrl.embedded.websocket.AutoReconnectWebsocketClient;
import de.blitzdose.serverctrl.embedded.websocket.WebsocketClient;
import org.bukkit.Bukkit;
import org.bukkit.plugin.java.JavaPlugin;

import javax.net.ssl.SSLHandshakeException;
import java.net.ConnectException;
import java.net.URI;

public final class ServerCtrlClient extends JavaPlugin {
    private AppenderConsoleSaver consoleSaver;
    final ApiInstance apiInstance = new ApiInstance(this);
    private final ConsoleLogger logger = new ConsoleLogger("ServerCtrlClient", apiInstance);

    private AutoReconnectWebsocketClient client = null;

    @Override
    public void onEnable() {
        try {
            apiInstance.loadProvisioningPack();
        } catch (Exception e) {
            logger.error("Could not find or load provisioning pack in " + apiInstance.getPluginFolder());
            Bukkit.getPluginManager().disablePlugin(this);
            return;
        }

        this.consoleSaver = new AppenderConsoleSaver(apiInstance.getConsoleLogPath(), true);
        SystemDataLogger systemDataLogger = new SystemDataLogger();

        client = new AutoReconnectWebsocketClient(
                URI.create(apiInstance.getProvisioningBackendWebsocketURI()),
                apiInstance.getProvisioningAuthToken(),
                apiInstance.getProvisioningServerCert(),
                new Implementations(apiInstance, consoleSaver, systemDataLogger),
                new WebsocketClient.StatusListener() {
                    @Override
                    public void onOpen() {
                        logger.info("Successfully connected to backend");
                    }

                    @Override
                    public void onClose(String reason) {
                        logger.error("Backend connection failed");
                        logger.info("Trying to reconnect in background...");
                    }

                    @Override
                    public void onError(Exception e) {
                        if (e instanceof ConnectException) {
                            logger.error("Backend refused the connection");
                        } else if (e instanceof SSLHandshakeException) {
                            logger.error("Backend certificate could not be validated, did you change it? If yes, please create a new provisioning pack for this server");
                        }
                        logger.info("Trying to reconnect in background...");
                    }
                }
        );

        client.connect();

        Bukkit.getScheduler().runTaskTimerAsynchronously(this, systemDataLogger, 20L, 20L);
    }

    @Override
    public void onDisable() {
        if (client != null) {
            client.disconnect();
        }
        if (consoleSaver != null) {
            consoleSaver.clearLogFile();
        }
    }
}
