package de.blitzdose.serverctrl.embedded.websocket;

import de.blitzdose.serverctrl.embedded.Implementations;

import java.net.URI;
import java.util.Timer;
import java.util.TimerTask;

public class AutoReconnectWebsocketClient implements WebsocketClient.StatusListener {

    private final long SUPPRESS_ERROR = 60_000;
    private long lastCloseLogged = 0;
    private long lastErrorLogged = 0;
    private String lastError = "";
    private String lastClosedError = "";

    private final URI serverUri;
    private final String authToken;
    private final String serverCert;
    private final Implementations implementations;
    private final WebsocketClient.StatusListener statusListener;

    private WebsocketClient websocketClient;

    private boolean reconnect = false;
    private boolean isReconnecting = false;

    public AutoReconnectWebsocketClient(URI serverUri, String authToken, String serverCert, Implementations implementations, WebsocketClient.StatusListener statusListener) {
        this.serverUri = serverUri;
        this.authToken = authToken;
        this.serverCert = serverCert;
        this.implementations = implementations;
        this.statusListener = statusListener;
    }

    public void connect() {
        reconnect = true;
        websocketClient = new WebsocketClient(
                serverUri,
                authToken,
                serverCert,
                implementations,
                this
        );
        websocketClient.connect();
    }

    private void reconnect() {
        if (isReconnecting) return;
        isReconnecting = true;
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                connect();
                isReconnecting = false;
            }
        }, 3000);
    }

    public void disconnect() {
        reconnect = false;
        if (websocketClient != null && websocketClient.isOpen()) {
            websocketClient.close();
        }
    }

    @Override
    public void onOpen() {
        lastError = "";
        this.statusListener.onOpen();
    }

    @Override
    public void onClose(String reason) {
        if (!lastClosedError.equals(reason) || lastCloseLogged + SUPPRESS_ERROR < System.currentTimeMillis()) {
            this.statusListener.onClose(reason);
            lastCloseLogged = System.currentTimeMillis();
        }
        lastClosedError = reason;
        if (reconnect) reconnect();
    }

    // Only pass the error if the exception changed or last pass was 1 minute ago
    @Override
    public void onError(Exception e) {
        if (!lastError.equals(e.getClass().getName() + ":" + e.getMessage()) || lastErrorLogged + SUPPRESS_ERROR < System.currentTimeMillis()) {
            this.statusListener.onError(e);
            lastErrorLogged = System.currentTimeMillis();
        }
        lastError = e.getClass().getName() + ":" + e.getMessage();
    }
}
