package de.blitzdose.clientConnection;

public class ProvisionedClient {
    private String name;
    private final String accessTokenHash;
    private boolean pending;
    private long lastConnected;

    public ProvisionedClient(String name, String accessTokenHash, boolean pending, long lastConnected) {
        this.name = name;
        this.accessTokenHash = accessTokenHash;
        this.pending = pending;
        this.lastConnected = lastConnected;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAccessTokenHash() {
        return accessTokenHash;
    }

    public boolean isPending() {
        return pending;
    }

    public void setPending(boolean pending) {
        this.pending = pending;
    }

    public long getLastConnected() {
        return lastConnected;
    }

    public void setLastConnected(long lastConnected) {
        this.lastConnected = lastConnected;
    }
}
