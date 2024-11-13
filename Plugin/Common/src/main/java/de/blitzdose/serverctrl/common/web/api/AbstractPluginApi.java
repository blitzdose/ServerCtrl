package de.blitzdose.serverctrl.common.web.api;

public abstract class AbstractPluginApi {
    public abstract void setPort(int port);
    public abstract void setHTTPS(boolean https);

    public abstract int getPort();
    public abstract boolean isHTTPS();

    public abstract String getKeystorePath();
    public abstract String getRootCAPath();
}
