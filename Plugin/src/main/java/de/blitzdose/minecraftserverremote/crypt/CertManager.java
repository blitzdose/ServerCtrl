package de.blitzdose.minecraftserverremote.crypt;

import inet.ipaddr.HostName;
import inet.ipaddr.HostNameException;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.x509.GeneralNames;
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
import java.security.*;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.Date;



public class CertManager {
    public static KeyStore keystoreFromCertificate(byte[] certFile, byte[] pivkeyFile) {
        try {
            byte[] certBytes = parseDERFromPEM(certFile, "-----BEGIN CERTIFICATE-----", "-----END CERTIFICATE-----");

            byte[] keyBytes;
            try {
                keyBytes = parseDERFromPEM(pivkeyFile, "-----BEGIN PRIVATE KEY-----", "-----END PRIVATE KEY-----");
            } catch (IndexOutOfBoundsException e) {
                keyBytes = parseDERFromPEM(pivkeyFile, "-----BEGIN RSA PRIVATE KEY-----", "-----END RSA PRIVATE KEY-----");
            }

            X509Certificate cert = generateCertificateFromDER(certBytes);

            RSAPrivateKey key;
            try {
                key = generatePrivateKeyFromDER8(keyBytes);
            } catch (InvalidKeySpecException e ) {
                key = generatePrivateKeyFromDER1(pivkeyFile);
            }

            KeyStore keystore = KeyStore.getInstance("PKCS12");
            keystore.load(null);
            keystore.setKeyEntry("cert", key, "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray(), new X509Certificate[]{cert});

            return keystore;

        } catch (IOException | KeyStoreException | CertificateException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    private static byte[] parseDERFromPEM(byte[] pem, String beginDelimiter, String endDelimiter) throws IndexOutOfBoundsException {
        String data = new String(pem);
        String[] tokens = data.split(beginDelimiter);
        tokens = tokens[1].split(endDelimiter);
        return Base64.getDecoder().decode(tokens[0].replaceAll("[\n|\r]", ""));
    }

    private static RSAPrivateKey generatePrivateKeyFromDER8(byte[] keyBytes) throws InvalidKeySpecException, NoSuchAlgorithmException {
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory factory = KeyFactory.getInstance("RSA");
        return (RSAPrivateKey) factory.generatePrivate(spec);
    }

    private static RSAPrivateKey generatePrivateKeyFromDER1(byte[] file) throws IOException {
        PEMParser reader = new PEMParser(new InputStreamReader(new ByteArrayInputStream(file)));
        PrivateKeyInfo info = null;
        Object bouncyCastleResult = reader.readObject();

        if (bouncyCastleResult instanceof PrivateKeyInfo) {
            info = (PrivateKeyInfo) bouncyCastleResult;
        } else if ( bouncyCastleResult instanceof PEMKeyPair) {
            PEMKeyPair keys = (PEMKeyPair) bouncyCastleResult;
            info = keys.getPrivateKeyInfo();
        }

        JcaPEMKeyConverter converter = new JcaPEMKeyConverter();
        PrivateKey privateKeyJava = converter.getPrivateKey(info);
        return (RSAPrivateKey) privateKeyJava;
    }

    private static X509Certificate generateCertificateFromDER(byte[] certBytes) throws CertificateException {
        CertificateFactory factory = CertificateFactory.getInstance("X.509");

        return (X509Certificate) factory.generateCertificate(new ByteArrayInputStream(certBytes));
    }

    static GeneratedCert generateCertificate(String cnName, String domain, GeneratedCert issuer, boolean isCA)
            throws GeneralSecurityException, IOException, OperatorCreationException {
        // Generate the key-pair with the official Java API's
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        KeyPair certKeyPair = keyGen.generateKeyPair();
        X500Name name = new X500Name("CN=" + cnName);
        // If you issue more than just test certificates, you might want a decent serial number schema ^.^
        BigInteger serialNumber = BigInteger.valueOf(System.currentTimeMillis());
        Instant validFrom = Instant.now();
        Instant validUntil = validFrom.plus(10 * 360, ChronoUnit.DAYS);

        // If there is no issuer, we self-sign our certificate.
        X500Name issuerName;
        PrivateKey issuerKey;
        if (issuer == null) {
            issuerName = name;
            issuerKey = certKeyPair.getPrivate();
        } else {
            issuerName = new X500Name(issuer.certificate.getSubjectX500Principal().getName());
            issuerKey = issuer.privateKey;
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
            if (isIP(new HostName(domain))) {
                builder.addExtension(Extension.subjectAlternativeName, false,
                        new GeneralNames(new GeneralName(GeneralName.iPAddress, domain)));
            } else {
                builder.addExtension(Extension.subjectAlternativeName, false,
                        new GeneralNames(new GeneralName(GeneralName.dNSName, domain)));
            }
        }

        ContentSigner signer = new JcaContentSignerBuilder("SHA256WithRSA").build(issuerKey);
        X509CertificateHolder certHolder = builder.build(signer);
        X509Certificate cert = new JcaX509CertificateConverter().getCertificate(certHolder);

        return new GeneratedCert(certKeyPair.getPrivate(), cert);
    }

    public static void generateAndSaveSelfSignedCertificate(String domain, String path1, String path2) throws GeneralSecurityException, IOException, OperatorCreationException {
        KeyStore ks = KeyStore.getInstance("PKCS12");

        char[] pwdArray = "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray();
        ks.load(null, pwdArray);

        GeneratedCert rootCA = CertManager.generateCertificate("ServerCtrl RootCA", null, null, true);
        GeneratedCert cert = CertManager.generateCertificate("ServerCtrl Certificate", domain, rootCA, false);

        ks.setKeyEntry("cert", cert.privateKey, pwdArray, new Certificate[]{cert.certificate});
        ks.setKeyEntry("rootCA", rootCA.privateKey, pwdArray, new Certificate[]{rootCA.certificate});

        try (FileOutputStream fos = new FileOutputStream(path1)) {
            ks.store(fos, pwdArray);
        }

        if (path2 != null) {
            PrintWriter printWriter = new PrintWriter(path2);

            Base64.Encoder encoder = Base64.getEncoder();
            printWriter.println("-----BEGIN CERTIFICATE-----");
            printWriter.println(encoder.encodeToString(rootCA.certificate.getEncoded()));
            printWriter.println("-----END CERTIFICATE-----");

            printWriter.close();
        }
    }

    static boolean isIP(HostName host) {
        try {
            host.validate();
            return host.isAddress();
        } catch(HostNameException e) {
            return false;
        }
    }
}