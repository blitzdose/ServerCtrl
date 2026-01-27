package de.blitzdose.serverctrl.common.crypt;

import java.security.PrivateKey;
import java.security.cert.X509Certificate;

public record GeneratedCert(PrivateKey privateKey, X509Certificate certificate) {
}