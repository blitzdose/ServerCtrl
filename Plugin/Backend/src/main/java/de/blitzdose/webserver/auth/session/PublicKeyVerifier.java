package de.blitzdose.webserver.auth.session;

import de.blitzdose.webserver.WebServer;

import java.security.PublicKey;
import java.security.Signature;

public class PublicKeyVerifier {

    public static boolean verify(String username, String publicKeyHash, String challengeId, byte[] signature) {
        byte[] nonce = WebServer.publicKeyManager.getAndRemoveNonce(challengeId);
        if (nonce == null) return false;

        PublicKey publicKey = WebServer.publicKeyManager.getPublicKey(publicKeyHash, username);
        if (publicKey == null) return false;

        try {
            Signature verifier = Signature.getInstance("SHA256withECDSA");
            verifier.initVerify(publicKey);
            verifier.update(nonce);
            return verifier.verify(signature);
        } catch (Exception e) {
            return false;
        }
    }

}
