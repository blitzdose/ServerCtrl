package de.blitzdose.serverctrl.embedded.websocket;

import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.Implementations;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import java.net.URI;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Map;


public class WebsocketClient extends WebSocketClient {
    private final FunctionMapper functionMapper;
    private final StatusListener statusListener;


    public WebsocketClient(URI serverUri, String authToken, String serverCert, Implementations implementations, StatusListener statusListener) {
        super(serverUri, Map.of("Authorization", "Bearer " + authToken));
        this.functionMapper = new FunctionMapper(implementations);
        this.statusListener = statusListener;
        try {
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, new TrustManager[]{ new BackendTrustManager(CertManager.generateCertificateFromPEM(serverCert)) }, new java.security.SecureRandom());

            this.setSocketFactory(sslContext.getSocketFactory());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void onOpen(ServerHandshake serverHandshake) {
        statusListener.onOpen();
    }

    @Override
    public void onMessage(String s) {

    }

    @Override
    public void onMessage(ByteBuffer bytes) {
        WebsocketRequest request = WebsocketRequest.deserialize(bytes.array());
        WebsocketResponse response = functionMapper.mapFunction(request);
        byte[] responseBytes = response.serialize().getBytes(StandardCharsets.UTF_8);
        this.send(responseBytes);
    }

    @Override
    public void onClose(int i, String s, boolean b) {
        statusListener.onClose(s);
    }

    @Override
    public void onError(Exception e) {
        statusListener.onError(e);
    }

    public interface StatusListener {
        void onOpen();
        void onClose(String reason);
        void onError(Exception e);
    }
}
