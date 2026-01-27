package de.blitzdose.serverctrl.embedded.websocket;

import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;
import java.security.KeyStore;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

public final class BackendTrustManager implements X509TrustManager {

    private final X509Certificate pinnedCert;
    private final X509TrustManager systemTrust;

    public BackendTrustManager(X509Certificate pinnedCert) throws Exception {
        this.pinnedCert = pinnedCert;

        // Load default system trust store
        TrustManagerFactory tmf =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init((KeyStore) null);

        this.systemTrust = (X509TrustManager) tmf.getTrustManagers()[0];
    }

    @Override
    public void checkServerTrusted(X509Certificate[] chain, String authType)
            throws CertificateException {

        // Pinned certificate check
        for (X509Certificate cert : chain) {
            if (cert.equals(pinnedCert)) {
                return; // PIN MATCH
            }
        }

        // System CA validation
        try {
            systemTrust.checkServerTrusted(chain, authType);
            return; // SYSTEM TRUSTED
        } catch (CertificateException e) {
            // continue to failure
        }

        // Reject
        throw new CertificateException(
                "Server certificate is neither pinned nor trusted by system CAs");
    }

    @Override
    public void checkClientTrusted(X509Certificate[] chain, String authType) {
        throw new UnsupportedOperationException("Client certs not supported");
    }

    @Override
    public X509Certificate[] getAcceptedIssuers() {
        return systemTrust.getAcceptedIssuers();
    }
}