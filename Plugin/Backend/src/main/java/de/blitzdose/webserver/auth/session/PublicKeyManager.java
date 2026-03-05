package de.blitzdose.webserver.auth.session;

import org.jetbrains.annotations.Nullable;

import java.security.PublicKey;
import java.security.SecureRandom;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public class PublicKeyManager {
    private final ConcurrentHashMap<String, byte[]> challenges = new ConcurrentHashMap<>();
    private final SecureRandom random = new SecureRandom();

    private final UserManager userManager;

    public PublicKeyManager(UserManager userManager) {
        this.userManager = userManager;
    }

    public PublicKey getPublicKey(String hash, String username) {
        return userManager.getUserByUsername(username).getPublicKeys().get(hash);
    }

    public Challenge createNonce() {
        byte[] nonce = new byte[32];
        random.nextBytes(nonce);
        String id = UUID.randomUUID().toString();
        challenges.put(id, nonce);
        return new Challenge(nonce, id);
    }

    public byte @Nullable [] getAndRemoveNonce(String challengeId) {
        return challenges.remove(challengeId);
    }

    public record Challenge(byte[] nonce, String id) {
    }
}
