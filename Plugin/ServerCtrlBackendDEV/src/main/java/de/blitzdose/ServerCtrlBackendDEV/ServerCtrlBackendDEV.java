package de.blitzdose.ServerCtrlBackendDEV;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.logger.ConsoleLogger;
import de.blitzdose.webserver.WebServer;
import de.blitzdose.webserver.WebserverConfig;

import java.io.File;
import java.io.IOException;

public class ServerCtrlBackendDEV {

    public static void main(String[] args) throws IOException {
        BackendApiInstance backendApiInstance = new BackendApiInstanceImpl();

        File file = new File("data");
        if (!file.exists()) {
            file.mkdir();
        }

        new Thread(() -> {
            WebServer webServer = new WebServer(
                    new WebserverConfig(backendApiInstance.configGetBoolean("Webserver.debug"), backendApiInstance.configGetBoolean("Webserver.https"), backendApiInstance.configGetBoolean("Webserver.frontend"), backendApiInstance.configGetInt("Webserver.port")),
                    new ConsoleLogger("ServerCtrlBackend", backendApiInstance),
                    backendApiInstance
            );

            webServer.start();
        }).start();
    }
}