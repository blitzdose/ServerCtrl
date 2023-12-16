package de.blitzdose.minecraftserverremote.crypt;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class CryptManager {
    public static String getHash(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().encodeToString(encodedhash);
        } catch (NoSuchAlgorithmException ignored) {
            return null;
        }
    }
}
