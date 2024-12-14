package de.blitzdose.serverctrl.common.crypt;

import kotlin.Pair;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

/**
 * Aktuell: 4080 schafft 8 stelliges Passwort (groß + klein + Zahlen + Sonderzeichen (82 Zeichen)) in 43 Stunden
 * Mit PBKDF2-SHA512 und 999 iterationen: 299.481 Stunden = 35 Jahre
 * **/

public class CryptManager {
    public static String getLegacyHash(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().encodeToString(encodedhash);
        } catch (NoSuchAlgorithmException ignored) {
            return null;
        }
    }

    public static Pair<String, String> getPBKDF2Hash(String hash) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        return getPBKDF2Hash(salt, hash);
    }

    public static Pair<String, String> getPBKDF2Hash(byte[] salt, String hash) {
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance( "PBKDF2WithHmacSHA512");
            PBEKeySpec spec = new PBEKeySpec(hash.toCharArray(), salt, 10000, 512);
            SecretKey key = skf.generateSecret(spec);
            byte[] res = key.getEncoded();
            return new Pair<>(Base64.getUrlEncoder().encodeToString(salt), Base64.getUrlEncoder().encodeToString(res));
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e ) {
            return null;
        }
    }
}
