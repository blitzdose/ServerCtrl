package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

public class ServerApiImpl extends AbstractServerApi {

    private final ApiInstance instance;

    public ServerApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public byte[] getServerIcon(String system) {
        try {
            return FileUtils.readFileToByteArray(new File("server-icon.png"));
        } catch (IOException e) {
            return null;
        }
    }

    @Override
    public String getServerName(String system) {
        return instance.configGetString("Webserver.servername");
    }

    @Override
    public void setServerName(String system, String name) {
        instance.configUpdate("Webserver.servername", name);
    }

    @Override
    public ServerData getServerData(String system) {
        return instance.getServerData();
    }

    @Override
    public Properties getServerProperties(String system) {
        return instance.getServerProperties();
    }

    @Override
    public boolean setServerProperties(String system, Properties properties) {
        return instance.setServerProperties(properties);
    }

    @Override
    public void stopServer(String system) {
        instance.shutdownServer();
    }

    @Override
    public void restartServer(String system) {
        instance.restartServer();
    }

    @Override
    public void reloadServer(String system) {
        instance.reloadServer();
    }
}
