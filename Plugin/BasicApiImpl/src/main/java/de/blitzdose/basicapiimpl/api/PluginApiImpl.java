package de.blitzdose.basicapiimpl.api;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractPluginApi;

public class PluginApiImpl extends AbstractPluginApi {

    private final ApiInstance instance;

    public PluginApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public void setPort(int port) {
        instance.configUpdate("Webserver.port", port);
    }

    @Override
    public void setHTTPS(boolean https) {
        instance.configUpdate("Webserver.https", https);
    }

    @Override
    public int getPort() {
        return instance.configGetInt("Webserver.port");
    }

    @Override
    public boolean isHTTPS() {
        return instance.configGetBoolean("Webserver.https");
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
