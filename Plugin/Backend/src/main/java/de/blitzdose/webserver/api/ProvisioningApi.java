package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.ProvisionedClient;
import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.websocket.ProvisioningPack;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import kotlin.Pair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.util.List;

public class ProvisioningApi {

    public static void add(Context context) throws Exception {
        String name = context.queryParam("name");
        if (name == null || name.matches("^[A-Za-z0-9_-]+$")) {
            WebServer.returnFailedJson(context);
        }
        String publicURL = context.queryParam("publicURL");
        Pair<String, ProvisionedClient> provisionedClientPair = WebServer.websocketClientManager.generateClient(name);
        String accessToken = provisionedClientPair.component1();
        String caCert = CertManager.getRootCA(WebServer.backendApiInstance.getRootCAPath());
        byte[] provisioningPack = new ProvisioningPack(name, accessToken, caCert, publicURL).generatePackFile();
        WebServer.returnFile(context, name + ".sctrl", provisioningPack.length, new BufferedInputStream(new ByteArrayInputStream(provisioningPack)));
    }

    public static void list(Context context) {
        List<ProvisionedClient> provisionedClients = WebServer.websocketClientManager.listAllClients();
        JSONArray jsonArray = new JSONArray();
        for (ProvisionedClient provisionedClient : provisionedClients) {
            jsonArray.put(
                    new JSONObject()
                            .put("name", provisionedClient.getName())
                            .put("pending", provisionedClient.isPending())
                            .put("lastConnected", provisionedClient.getLastConnected()
                            )
            );
        }
        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", jsonArray));
    }

    public static void delete(Context context) {
        String name = WebServer.getData(context, String.class);
        WebServer.websocketClientManager.deleteByName(name);
        try {
            WebsocketHandler.terminateConnection(name);
        } catch (WebsocketException.SystemNotConnectedException ignored) { }
        WebServer.returnSuccessfulJson(context, new JSONObject());
    }
}
