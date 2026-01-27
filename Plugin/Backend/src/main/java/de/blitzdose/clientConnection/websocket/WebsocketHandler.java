package de.blitzdose.clientConnection.websocket;

import de.blitzdose.clientConnection.ProvisionedClient;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.websocket.*;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.*;

public class WebsocketHandler {

    private static final Map<String, CompletableFuture<WebsocketResponse>> pendingRequests = new ConcurrentHashMap<>();

    public static void onConnect(WsConnectContext context) {
        String name = WebsocketAccessManager.getTokenFromHeader(context).component1();
        ProvisionedClient provisionedClient = WebServer.websocketClientManager.findClientByName(name);
        WebServer.websocketClientManager.sessions.put(name, context);
        context.enableAutomaticPings();
        provisionedClient.setPending(false);
        provisionedClient.setLastConnected(System.currentTimeMillis());
        WebServer.websocketClientManager.updateClient(provisionedClient);
    }

    public static void onClose(WsCloseContext context) {
        String name = WebsocketAccessManager.getTokenFromHeader(context).component1();
        WebServer.websocketClientManager.sessions.remove(name);

        ArrayList<String> removableRequests = new ArrayList<>();
        for (Map.Entry<String, CompletableFuture<WebsocketResponse>> pendingRequest : pendingRequests.entrySet()) {
            if (pendingRequest.getKey().startsWith(name)) {
                removableRequests.add(pendingRequest.getKey());
            }
        }
        for (String removableRequest : removableRequests) {
            CompletableFuture<WebsocketResponse> future = pendingRequests.remove(removableRequest);
            if (future != null) {
                future.completeExceptionally(new Exception("Client error"));
            }
        }
    }

    public static void onError(WsErrorContext context) {
        String name = WebsocketAccessManager.getTokenFromHeader(context).component1();
        WebServer.websocketClientManager.sessions.remove(name);

        ArrayList<String> removableRequests = new ArrayList<>();
        for (Map.Entry<String, CompletableFuture<WebsocketResponse>> pendingRequest : pendingRequests.entrySet()) {
            if (pendingRequest.getKey().startsWith(name)) {
                removableRequests.add(pendingRequest.getKey());
            }
        }
        for (String removableRequest : removableRequests) {
            CompletableFuture<WebsocketResponse> future = pendingRequests.remove(removableRequest);
            if (future != null) {
                future.completeExceptionally(new Exception("Client error"));
            }
        }
    }


    public static void onMessage(WsBinaryMessageContext context) {
        String name = WebsocketAccessManager.getTokenFromHeader(context).component1();
        ProvisionedClient provisionedClient = WebServer.websocketClientManager.findClientByName(name);
        provisionedClient.setLastConnected(System.currentTimeMillis());
        WebServer.websocketClientManager.updateClient(provisionedClient);

        WebsocketResponse websocketResponse = WebsocketResponse.deserialize(context.data());

        CompletableFuture<WebsocketResponse> future = pendingRequests.remove(name + ":" + websocketResponse.identifier());
        if (future != null) {
            future.complete(websocketResponse);
        }
    }

    public static void terminateConnection(String system) throws WebsocketException.SystemNotConnectedException {
        WsContext wsContext = WebServer.websocketClientManager.sessions.get(system);
        if (wsContext == null) {
            throw new WebsocketException.SystemNotConnectedException();
        }
        wsContext.closeSession(4000, "Access revoked");
    }

    public static WebsocketResponse tunnelThroughWebsocket(String system, WebsocketRequest request) throws WebsocketException.SystemNotFoundException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException, WebsocketException.RequestNotSuccessfulException {
        return tunnelThroughWebsocket(system, request, true);
    }

    public static WebsocketResponse tunnelThroughWebsocket(String system, WebsocketRequest request, boolean handleResponseNotSuccessful) throws WebsocketException.SystemNotFoundException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException, WebsocketException.RequestNotSuccessfulException {
        if (system == null) {
            throw new WebsocketException.SystemNotFoundException();
        }

        WsContext wsContext = WebServer.websocketClientManager.sessions.get(system);
        if (wsContext == null) {
            throw new WebsocketException.SystemNotConnectedException();
        }

        CompletableFuture<WebsocketResponse> responseFuture = new CompletableFuture<>();
        pendingRequests.put(system + ":" + request.identifier(), responseFuture);

        wsContext.send(ByteBuffer.wrap(request.serialize().getBytes(StandardCharsets.UTF_8)));

        try {
            WebsocketResponse response = responseFuture.get(30, TimeUnit.SECONDS);
            if (!response.success() && handleResponseNotSuccessful) {
                throw new WebsocketException.RequestNotSuccessfulException();
            }
            return response;
        } catch (InterruptedException | ExecutionException | TimeoutException e) {
            throw new WebsocketException.TimeoutException();
        }
    }
}
