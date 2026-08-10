package de.blitzdose.ServerCtrlClientDEV;

import de.blitzdose.serverctrl.common.logging.Logger;
import de.blitzdose.serverctrl.consolesaver.appenderconsolesaver.AppenderConsoleSaver;
import de.blitzdose.serverctrl.embedded.Implementations;
import de.blitzdose.serverctrl.embedded.SystemDataLogger;
import de.blitzdose.serverctrl.embedded.websocket.AutoReconnectWebsocketClient;
import de.blitzdose.serverctrl.embedded.websocket.WebsocketClient;

import javax.net.ssl.SSLHandshakeException;
import java.net.ConnectException;
import java.net.URI;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ServerCtrlClientDEV {
    private static AppenderConsoleSaver consoleSaver;
    final static ApiInstance apiInstance = new ApiInstance();
    private static final Logger logger = new Logger() {
        @Override
        public void log(String message) {
            System.out.println("LOG: " + message);
        }

        @Override
        public void error(String message) {
            System.out.println("ERROR: " + message);
        }

        @Override
        public void info(String message) {
            System.out.println("INFO: " + message);
        }
    };

    private static AutoReconnectWebsocketClient client = null;

    public static void main(String[] args) {
        try {
            apiInstance.loadProvisioningPack();
        } catch (Exception e) {
            System.out.println("Could not find or load provisioning pack in " + apiInstance.getPluginFolder());
            return;
        }

        System.out.println("Loaded provisioning pack");

        consoleSaver = new AppenderConsoleSaver(apiInstance.getConsoleLogPath(), true);
        SystemDataLogger systemDataLogger = new SystemDataLogger();

        System.out.println("Created console saver and system logger");

        client = new AutoReconnectWebsocketClient(
                URI.create(apiInstance.getProvisioningBackendWebsocketURI()),
                apiInstance.getProvisioningAuthToken(),
                apiInstance.getProvisioningCACert(),
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

        System.out.println("Connect!");

        ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);
        executor.scheduleAtFixedRate(systemDataLogger, 1, 1, TimeUnit.SECONDS);
    }
}