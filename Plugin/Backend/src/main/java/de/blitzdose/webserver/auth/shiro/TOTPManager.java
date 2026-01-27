package de.blitzdose.webserver.auth.shiro;

import com.amdelamar.jotp.OTP;
import com.amdelamar.jotp.type.Type;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class TOTPManager {
    static boolean checkTOTP(String secret, String code) {
        if (secret == null || secret.startsWith("$")) {
            return true;
        }
        try {
            String code1 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis() - 30000), 6, Type.TOTP);
            String code2 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis()), 6, Type.TOTP);
            String code3 = OTP.create(secret, OTP.timeInHex(System.currentTimeMillis() + 30000), 6, Type.TOTP);

            if (!code1.equals(code) && !code2.equals(code) && !code3.equals(code)) {
                return false;
            }
        } catch (InvalidKeyException | NoSuchAlgorithmException | IOException e) {
            return false;
        }
        return true;
    }

    public static String verifyTOTP(String totpSecret, String code) {
        String secret = totpSecret.replace("$", "");
        if (checkTOTP(secret, code)) {
            return secret;
        } else {
            return null;
        }
    }

    public static String generateSecret() {
        return OTP.randomBase32(20);
    }
}
