package de.blitzdose.apiimpl;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import org.bouncycastle.operator.OperatorCreationException;
import org.json.JSONObject;

import java.io.IOException;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
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
        if (!data.has("cert") || !data.has("certKey") || !data.has("ca")) {
            return new WebsocketResponse(false, null);
        }

        String certBase64 = data.getString("cert");
        String keyBase64 = data.getString("certKey");
        String caBase64 = data.getString("ca");

        byte[] cert = Base64.getDecoder().decode(certBase64);
        byte[] key = Base64.getDecoder().decode(keyBase64);
        byte[] ca = Base64.getDecoder().decode(caBase64);

        try {
            X509Certificate certificate = CertManager.Converter.X509Certificate.fromPEM(new String(cert));
            PrivateKey privateKey = CertManager.Converter.PrivateKey.fromPEM(new String(key));
            X509Certificate CACertificate = CertManager.Converter.X509Certificate.fromPEM(new String(ca));

            CertManager.KeyStoreManager keyStoreManager = CertManager.withKeyStoreManager(WebServer.backendApiInstance.getKeystorePath(), WebServer.localEncryptionManager.getPassword());
            KeyStore keyStore = keyStoreManager.generator().parse(certificate, privateKey);
            keyStoreManager.saveKeyStore(keyStore);
            CertManager.saveCertificateToFile(CACertificate, WebServer.backendApiInstance.getRootCAPath());
        } catch (CertificateException | IOException | KeyStoreException | NoSuchAlgorithmException e) {
            return new WebsocketResponse(false, null);
        }

        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse generateCertificate(String name) {
        try {
            CertManager.KeyStoreManager keyStoreManager = CertManager.withKeyStoreManager(WebServer.backendApiInstance.getKeystorePath(), WebServer.localEncryptionManager.getPassword());
            KeyStore keyStore = keyStoreManager.generator().generateCertificate(name);
            keyStoreManager.saveKeyStore(keyStore);
            CertManager.saveCertificateToFile(keyStoreManager.getCertificateFromKeystore(CertManager.CertificateType.ROOT_CA).certificate(), WebServer.backendApiInstance.getRootCAPath());
        } catch (GeneralSecurityException | IOException | OperatorCreationException e) {
            return new WebsocketResponse(false, null);
        }

        return new WebsocketResponse(true, null);
    }
}
