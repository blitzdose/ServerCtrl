package de.blitzdose.serverctrl.embedded.websocket;

import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;
import java.security.KeyStore;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

public final class BackendTrustManager implements X509TrustManager {

    private final X509TrustManager caTrust;
    private final X509TrustManager systemTrust;

    public BackendTrustManager(X509Certificate caCertificate) throws Exception {

        // --- System trust manager ---
        TrustManagerFactory systemTmf =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        systemTmf.init((KeyStore) null);
        systemTrust = (X509TrustManager) systemTmf.getTrustManagers()[0];

        // --- Custom CA trust manager ---
        KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
        ks.load(null); // empty keystore
        ks.setCertificateEntry("customCa", caCertificate);

        TrustManagerFactory customTmf =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        customTmf.init(ks);

        caTrust = (X509TrustManager) customTmf.getTrustManagers()[0];
    }

    @Override
    public void checkServerTrusted(X509Certificate[] chain, String authType)
            throws CertificateException {
        try {
            caTrust.checkServerTrusted(chain, authType);
            return;
        } catch (Exception ignored) {}

        systemTrust.checkServerTrusted(chain, authType);
    }

    @Override
    public void checkClientTrusted(X509Certificate[] chain, String authType) {
        throw new UnsupportedOperationException("Client certs not supported");
    }

    @Override
    public X509Certificate[] getAcceptedIssuers() {
        X509Certificate[] a = caTrust.getAcceptedIssuers();
        X509Certificate[] b = systemTrust.getAcceptedIssuers();

        X509Certificate[] all = new X509Certificate[a.length + b.length];
        System.arraycopy(a, 0, all, 0, a.length);
        System.arraycopy(b, 0, all, a.length, b.length);
        return all;
    }
}