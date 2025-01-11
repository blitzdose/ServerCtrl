package de.blitzdose.serverctrl.common.web.api;

import org.jetbrains.annotations.Nullable;

import java.util.Properties;

public abstract class AbstractServerApi {
    @Nullable
    public abstract byte[] getServerIcon(String system);

    @Nullable
    public abstract String getServerName(String system);
    public abstract void setServerName(String system, String name);

    public abstract ServerData getServerData(String system);

    public abstract Properties getServerProperties(String system);
    public abstract boolean setServerProperties(String system, Properties properties);

    public abstract void stopServer(String system);
    public abstract void restartServer(String system);
    public abstract void reloadServer(String system);

    public static class ServerData {
        private final String motd;
        private final int port;
        private final String version;
        private final int maxPlayers;
        private final boolean onlineMode;
        private final boolean allowEnd;
        private final boolean allowNether;
        private final boolean whitelist;
        private final boolean allowCommandBlock;
        private final ServerType type;

        public ServerData(String motd, int port, String version, int maxPlayers, boolean onlineMode, boolean allowEnd, boolean allowNether, boolean whitelist, boolean allowCommandBlock, ServerType type) {
            this.motd = motd;
            this.port = port;
            this.version = version;
            this.maxPlayers = maxPlayers;
            this.onlineMode = onlineMode;
            this.allowEnd = allowEnd;
            this.allowNether = allowNether;
            this.whitelist = whitelist;
            this.allowCommandBlock = allowCommandBlock;
            this.type = type;
        }

        public String getMotd() {
            return motd;
        }

        public int getPort() {
            return port;
        }

        public String getVersion() {
            return version;
        }

        public int getMaxPlayers() {
            return maxPlayers;
        }

        public boolean isOnlineMode() {
            return onlineMode;
        }

        public boolean isAllowEnd() {
            return allowEnd;
        }

        public boolean isAllowNether() {
            return allowNether;
        }

        public boolean hasWhitelist() {
            return whitelist;
        }

        public boolean isAllowCommandBlock() {
            return allowCommandBlock;
        }

        public ServerType getType() {
            return type;
        }

        public enum ServerType {
            BUNGEE,
            SPIGOT
        }
    }
}
