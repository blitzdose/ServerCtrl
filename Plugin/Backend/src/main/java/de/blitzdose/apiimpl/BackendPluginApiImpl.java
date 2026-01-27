package de.blitzdose.apiimpl;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import org.bouncycastle.operator.OperatorCreationException;
import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.KeyStore;
import java.util.Base64;

public class BackendPluginApiImpl {
    private final BackendApiInstance instance;

    public BackendPluginApiImpl(BackendApiInstance instance) {
        this.instance = instance;
    }

    public void setPort(int port) {
        instance.configUpdate("Webserver.port", port);
    }

    public void setHTTPS(boolean https) {
        instance.configUpdate("Webserver.https", https);
    }

    public int getPort() {
        return instance.configGetInt("Webserver.port");
    }

    public boolean isHTTPS() {
        return instance.configGetBoolean("Webserver.https");
    }

    public String getKeystorePath() {
        return instance.getKeystorePath();
    }

    public String getRootCAPath() {
        return instance.getRootCAPath();
    }

    public WebsocketResponse getPluginSettings() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("Port", getPort());
        jsonObject.put("Https", isHTTPS());

        return new WebsocketResponse(true, jsonObject);
    }

    public WebsocketResponse setPluginSettings(JSONObject data) {
        if (!data.has("Port") || !data.has("Https")) {
            return new WebsocketResponse(false, null);
        }

        setPort(data.getInt("Port"));
        setHTTPS(data.getBoolean("Https"));
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse setCertificate(JSONObject data) {
        if (!data.has("cert") || !data.has("certKey")) {
            return new WebsocketResponse(false, null);
        }

        String certBase64 = data.getString("cert");
        String keyBase64 = data.getString("certKey");

        byte[] cert = Base64.getDecoder().decode(certBase64);
        byte[] key = Base64.getDecoder().decode(keyBase64);

        KeyStore keyStore = CertManager.keystoreFromCertificate(cert, key);
        if (keyStore == null) {
            return new WebsocketResponse(false, null);
        }
        char[] pwdArray = "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray();
        try (FileOutputStream fos = new FileOutputStream(getKeystorePath())) {
            keyStore.store(fos, pwdArray);
        } catch (Exception e) {
            return new WebsocketResponse(false, null);
        }

        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse generateCertificate(String name) {
        try {
            CertManager.generateAndSaveSelfSignedCertificate(name, getKeystorePath(), getRootCAPath());
        } catch (GeneralSecurityException | IOException | OperatorCreationException e) {
            return new WebsocketResponse(false, null);
        }

        return new WebsocketResponse(true, null);
    }
}
