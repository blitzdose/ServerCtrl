package de.blitzdose.serverctrl.common.crypt;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class CryptManager {
    public static String getSHA256(byte[] data) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(data);
            return Base64.getEncoder().encodeToString(encodedhash);
        } catch (NoSuchAlgorithmException ignored) {
            return null;
        }
    }

    public static String generateSecurePassword(int length) {
        String CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder(length);

        SecureRandom rng;
        try {
            rng = SecureRandom.getInstanceStrong();
        } catch (NoSuchAlgorithmException e) {
            rng = new SecureRandom();
        }

        for (int i = 0; i < length; i++) {
            int index = rng.nextInt(CHARSET.length());
            password.append(CHARSET.charAt(index));
        }

        return password.toString();
    }
}
