package de.blitzdose.clientConnection.websocket;

import de.blitzdose.clientConnection.ProvisionedClient;
import de.blitzdose.clientConnection.ProvisionedClientDao;
import de.blitzdose.serverctrl.common.crypt.CryptManager;
import de.blitzdose.webserver.auth.session.PasswordVerifier;
import io.javalin.websocket.WsContext;
import kotlin.Pair;
import org.jdbi.v3.core.Jdbi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WebsocketClientManager {

    public final Map<String, WsContext> sessions = new HashMap<>();
    private final Jdbi jdbi;

    public WebsocketClientManager(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public void insertClient(ProvisionedClient provisionedClient)  {
        jdbi.onDemand(ProvisionedClientDao.class).insertClient(provisionedClient);
    }

    public void updateClient(ProvisionedClient provisionedClient) {
        jdbi.onDemand(ProvisionedClientDao.class).updateClient(provisionedClient);
    }

    public ProvisionedClient findClientByName(String name) {
        return jdbi.onDemand(ProvisionedClientDao.class).findClientByName(name);
    }

    public List<ProvisionedClient> listAllClients() {
        return jdbi.onDemand(ProvisionedClientDao.class).listAllClients();
    }

    public void deleteByName(String name) {
        jdbi.onDemand(ProvisionedClientDao.class).deleteByName(name);
    }

    public Pair<String, ProvisionedClient> generateClient(String name) {
        String accessToken = CryptManager.generateSecurePassword(128);
        String accessTokenHash = PasswordVerifier.encrypt(accessToken);

        ProvisionedClient provisionedClient = new ProvisionedClient(name, accessTokenHash, true, 0);
        insertClient(provisionedClient);
        return new Pair<>(accessToken, provisionedClient);
    }

    public boolean checkAccessToken(String name, String accessToken) {
        ProvisionedClient savedClient = findClientByName(name);
        if (savedClient == null) {
            return false;
        }
        try {
            return PasswordVerifier.verify(accessToken, savedClient.getAccessTokenHash());
        } catch (Exception e) {
            return false;
        }
    }
}
