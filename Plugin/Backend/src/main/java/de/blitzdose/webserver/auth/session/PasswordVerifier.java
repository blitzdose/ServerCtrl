package de.blitzdose.webserver.auth.session;

import com.password4j.Argon2Function;
import com.password4j.HashingFunction;
import com.password4j.Password;
import com.password4j.types.Argon2;

public class PasswordVerifier {
    public static String encrypt(String password) {
        return Password.hash(password).addRandomSalt().with(getHashingFunction()).getResult();
    }

    public static boolean verify(String password, String hash) {
        return Password.check(password, hash).with(getHashingFunction());
    }

    private static HashingFunction getHashingFunction() {
        return Argon2Function.getInstance(65536, 3, 1, 32, Argon2.ID);
    }
}
