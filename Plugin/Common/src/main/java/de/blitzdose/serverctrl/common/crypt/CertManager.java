package de.blitzdose.serverctrl.common.crypt;

import inet.ipaddr.HostName;
import inet.ipaddr.HostNameException;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.x509.GeneralNames;
import org.bouncycastle.cert.CertIOException;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder;
import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;

import java.io.*;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.*;
import java.security.cert.*;
import java.security.cert.Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.Date;
import java.util.Random;

public class CertManager {
    public enum CertificateType {
        ROOT_CA("rootCA"),
        CERTIFICATE("cert");

        private final String serialized;

        CertificateType(String serialized) {
            this.serialized = serialized;
        }
    }

    public static class Converter {

        public static class PrivateKey {

            public static java.security.PrivateKey fromPEM(String pem) throws CertificateException, IOException {
                String derBase64;
                if (pem.contains("BEGIN PRIVATE KEY")) {
                    derBase64 = pem
                            .replace("-----BEGIN PRIVATE KEY-----", "")
                            .replace("-----END PRIVATE KEY-----", "")
                            .replaceAll("\\s", "");
                } else if (pem.contains("BEGIN RSA PRIVATE KEY")) {
                    derBase64 = pem
                            .replace("-----BEGIN RSA PRIVATE KEY-----", "")
                            .replace("-----END RSA PRIVATE KEY-----", "")
                            .replaceAll("\\s", "");
                } else {
                    throw new CertificateException();
                }

                byte[] der = Base64.getDecoder().decode(derBase64);

                try {
                    return fromDER8(der);
                } catch (InvalidKeySpecException | NoSuchAlgorithmException e) {
                    return fromDER1(pem.getBytes(StandardCharsets.UTF_8));
                }
            }

            private static RSAPrivateKey fromDER8(byte[] keyBytes) throws InvalidKeySpecException, NoSuchAlgorithmException {
                PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
                KeyFactory factory = KeyFactory.getInstance("RSA");
                return (RSAPrivateKey) factory.generatePrivate(spec);
            }

            private static RSAPrivateKey fromDER1(byte[] keyBytes) throws IOException {
                PEMParser reader = new PEMParser(new InputStreamReader(new ByteArrayInputStream(keyBytes)));
                PrivateKeyInfo info = null;
                Object bouncyCastleResult = reader.readObject();

                if (bouncyCastleResult instanceof PrivateKeyInfo) {
                    info = (PrivateKeyInfo) bouncyCastleResult;
                } else if (bouncyCastleResult instanceof PEMKeyPair keys) {
                    info = keys.getPrivateKeyInfo();
                }

                JcaPEMKeyConverter converter = new JcaPEMKeyConverter();
                java.security.PrivateKey privateKeyJava = converter.getPrivateKey(info);
                return (RSAPrivateKey) privateKeyJava;
            }

            public static String toPEM(java.security.PrivateKey privateKey) {
                Base64.Encoder encoder = Base64.getEncoder();

                return "-----BEGIN PRIVATE KEY-----\n" +
                        encoder.encodeToString(privateKey.getEncoded()) +
                        "\n-----END PRIVATE KEY-----";
            }
        }

        public static class X509Certificate {
            public static java.security.cert.X509Certificate fromPEM(String pem) throws CertificateException {
                pem = pem
                        .replace("-----BEGIN CERTIFICATE-----", "")
                        .replace("-----END CERTIFICATE-----", "")
                        .replaceAll("\\s", "");


                byte[] der = Base64.getDecoder().decode(pem);
                CertificateFactory cf = CertificateFactory.getInstance("X.509");
                return (java.security.cert.X509Certificate) cf.generateCertificate(new ByteArrayInputStream(der));
            }

            public static String toPEM(java.security.cert.X509Certificate certificate) throws CertificateEncodingException {
                Base64.Encoder encoder = Base64.getEncoder();

                return "-----BEGIN CERTIFICATE-----\n" +
                        encoder.encodeToString(certificate.getEncoded()) +
                        "\n-----END CERTIFICATE-----\n";
            }
        }
    }

    public static void saveCertificateToFile(X509Certificate certificate, String path) throws CertificateEncodingException, FileNotFoundException {
        PrintWriter printWriter = new PrintWriter(path);

        Base64.Encoder encoder = Base64.getEncoder();
        printWriter.println("-----BEGIN CERTIFICATE-----");
        printWriter.println(encoder.encodeToString(certificate.getEncoded()));
        printWriter.println("-----END CERTIFICATE-----");

        printWriter.close();
    }

    public static X509Certificate getCertificateFromFile(String path) throws IOException, CertificateException {
        String pem = Files.readString(Path.of(path));

        pem = pem.replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s+", ""); // remove all whitespace/newlines

        byte[] decoded = java.util.Base64.getDecoder().decode(pem);

        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        try (InputStream is = new java.io.ByteArrayInputStream(decoded)) {
            return (X509Certificate) cf.generateCertificate(is);
        }
    }

    public static KeyStoreManager withKeyStoreManager(String keyStorePath, String password) {
        return new KeyStoreManager(keyStorePath, password);
    }

    public static class KeyStoreManager {

        private final char[] encryptionPassword;
        private final String keystorePath;

        KeyStoreManager(String keystorePath, String encryptionPassword) {
            this.keystorePath = keystorePath;
            this.encryptionPassword = encryptionPassword.toCharArray();
        }

        public GeneratedCert getCertificateFromKeystore(CertificateType certificateType) throws KeyStoreException {
            KeyStore ks = KeyStore.getInstance("PKCS12");

            File keystoreFile = new File(keystorePath);
            if (keystoreFile.exists()) {
                try (FileInputStream fileInputStream = new FileInputStream(keystoreFile)) {
                    ks.load(fileInputStream, encryptionPassword);
                    if (ks.isKeyEntry(certificateType.serialized)) {
                        PrivateKey rootCAKey = (PrivateKey) ks.getKey(certificateType.serialized, encryptionPassword);
                        X509Certificate rootCACert = (X509Certificate) ks.getCertificate(certificateType.serialized);
                        return new GeneratedCert(rootCAKey, rootCACert);
                    }
                } catch (Exception e) {
                    throw new KeyStoreException(e);
                }
            }
            return null;
        }

        public void saveKeyStore(KeyStore keyStore) throws IOException, CertificateException, KeyStoreException, NoSuchAlgorithmException {
            try (FileOutputStream fos = new FileOutputStream(keystorePath)) {
                keyStore.store(fos, encryptionPassword);
            }
        }

        public Generator generator() {
            return new Generator();
        }

        public class Generator {

            private GeneratedCert generateKeyAndX509Certificate(String cnName, String domain, GeneratedCert issuer, boolean isCA)
                    throws NoSuchAlgorithmException, CertIOException, OperatorCreationException, CertificateException {
                // Generate the key-pair with the official Java API's
                KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
                KeyPair certKeyPair = keyGen.generateKeyPair();
                X500Name name = new X500Name("CN=" + cnName);
                // If you issue more than just test certificates, you might want a decent serial number schema ^.^
                byte[] randomBytes = new byte[8];
                new Random().nextBytes(randomBytes);
                BigInteger serialNumber = new BigInteger(randomBytes, 0, 8);
                Instant validFrom = Instant.now();
                Instant validUntil = validFrom.plus(10 * 360, ChronoUnit.DAYS);

                // If there is no issuer, we self-sign our certificate.
                X500Name issuerName;
                PrivateKey issuerKey;
                if (issuer == null) {
                    issuerName = name;
                    issuerKey = certKeyPair.getPrivate();
                } else {
                    issuerName = new X500Name(issuer.certificate().getSubjectX500Principal().getName());
                    issuerKey = issuer.privateKey();
                }

                // The cert builder to build up our certificate information
                JcaX509v3CertificateBuilder builder = new JcaX509v3CertificateBuilder(
                        issuerName,
                        serialNumber,
                        Date.from(validFrom), Date.from(validUntil),
                        name, certKeyPair.getPublic());

                // Make the cert to a Cert Authority to sign more certs when needed
                if (isCA) {
                    builder.addExtension(Extension.basicConstraints, true, new BasicConstraints(true));
                }
                // Modern browsers demand the DNS name entry
                if (domain != null) {
                    HostName host = new HostName(domain);
                    try {
                        host.validate();
                        if (host.isAddress()) {
                            builder.addExtension(Extension.subjectAlternativeName, false,
                                    new GeneralNames(new GeneralName(GeneralName.iPAddress, domain)));
                        } else {
                            throw new HostNameException(domain, 0);
                        }
                    } catch (HostNameException e) {
                        builder.addExtension(Extension.subjectAlternativeName, false,
                                new GeneralNames(new GeneralName(GeneralName.dNSName, domain)));
                    }
                }

                ContentSigner signer = new JcaContentSignerBuilder("SHA256WithRSA").build(issuerKey);
                X509CertificateHolder certHolder = builder.build(signer);
                X509Certificate cert = new JcaX509CertificateConverter().getCertificate(certHolder);

                return new GeneratedCert(certKeyPair.getPrivate(), cert);
            }

            public KeyStore generateCertificate(String domain) throws KeyStoreException, CertificateException, IOException, NoSuchAlgorithmException, OperatorCreationException {
                KeyStore ks = KeyStore.getInstance("PKCS12");
                ks.load(null, encryptionPassword);

                GeneratedCert rootCA = null;
                try {
                    rootCA = getCertificateFromKeystore(CertificateType.ROOT_CA);
                } catch (KeyStoreException ignored) {}

                if (rootCA == null) {
                    rootCA = generateKeyAndX509Certificate("ServerCtrl RootCA", null, null, true);
                }

                GeneratedCert cert = generateKeyAndX509Certificate("ServerCtrl Certificate", domain, rootCA, false);

                ks.setKeyEntry(CertificateType.CERTIFICATE.serialized, cert.privateKey(), encryptionPassword, new Certificate[]{cert.certificate()});
                ks.setKeyEntry(CertificateType.ROOT_CA.serialized, rootCA.privateKey(), encryptionPassword, new Certificate[]{rootCA.certificate()});

                return ks;
            }

            public KeyStore parse(X509Certificate certificate, PrivateKey privateKey) throws KeyStoreException, CertificateException, IOException, NoSuchAlgorithmException {
                KeyStore ks = KeyStore.getInstance("PKCS12");
                ks.load(null, encryptionPassword);

                ks.setKeyEntry(CertificateType.CERTIFICATE.serialized, privateKey, encryptionPassword, new Certificate[]{certificate});

                return ks;
            }
        }

    }
}
