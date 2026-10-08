import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

class ClientKey {
  ECPrivateKey privateKey;
  ECPublicKey publicKey;

  ClientKey(this.privateKey, this.publicKey);

  static ClientKey fromMap(Map<String, dynamic> json) {
    final publicKey = decodePublicKeyFromBase64(json["publicKey"]);
    final privateKey = decodePrivateKeyFromBase64(json["privateKey"]);
    return ClientKey(privateKey, publicKey);
  }

  static ECPublicKey decodePublicKeyFromBase64(String base64Key) {
    final bytes = base64Decode(base64Key);

    final parser = ASN1Parser(bytes);
    final topLevelSeq = parser.nextObject() as ASN1Sequence;

    final publicKeyBitString =
    topLevelSeq.elements![1] as ASN1BitString;

    final publicKeyBytes = publicKeyBitString.stringValues!;

    final domain = ECDomainParameters('secp256r1');
    final ecPoint = domain.curve.decodePoint(publicKeyBytes)!;

    return ECPublicKey(ecPoint, domain);
  }

  static ECPrivateKey decodePrivateKeyFromBase64(String base64Key) {
    final bytes = base64Decode(base64Key);

    final parser = ASN1Parser(bytes);
    final topLevelSeq = parser.nextObject() as ASN1Sequence;

    final privateKeyOctet =
    topLevelSeq.elements![2] as ASN1OctetString;

    final ecPrivateKeyBytes = privateKeyOctet.octets!;

    final ecParser = ASN1Parser(ecPrivateKeyBytes);
    final ecSeq = ecParser.nextObject() as ASN1Sequence;

    final privateKeyInnerOctet =
    ecSeq.elements![1] as ASN1OctetString;

    final privateKeyBytes = privateKeyInnerOctet.octets!;

    var result = BigInt.zero;
    for (final byte in privateKeyBytes) {
      result = (result << 8) | BigInt.from(byte);
    }

    final d = result;

    final domain = ECDomainParameters('secp256r1');

    return ECPrivateKey(d, domain);
  }

  static ClientKey generate() {
    final keyParams = ECKeyGeneratorParameters(ECCurve_secp256r1());

    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seed = Uint8List(32);
    for (int i = 0; i < seed.length; i++) {
      seed[i] = seedSource.nextInt(256);
    }
    secureRandom.seed(KeyParameter(seed));

    final keyGen = ECKeyGenerator()
      ..init(ParametersWithRandom(keyParams, secureRandom));
    final pair = keyGen.generateKeyPair();
    ECPrivateKey privateKey = pair.privateKey;
    ECPublicKey publicKey = pair.publicKey;
    return ClientKey(privateKey, publicKey);
  }

  List<int> signNonce(List<int> nonce) {
    final signer = Signer("SHA-256/ECDSA");

    final privParams = PrivateKeyParameter<ECPrivateKey>(privateKey);

    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seed = Uint8List(32);
    for (int i = 0; i < seed.length; i++) {
      seed[i] = seedSource.nextInt(256);
    }
    secureRandom.seed(KeyParameter(seed));

    signer.init(true, ParametersWithRandom(privParams, secureRandom));
    ECSignature sig = signer.generateSignature(Uint8List.fromList(nonce)) as ECSignature;

    final seq = ASN1Sequence()
      ..add(ASN1Integer(sig.r))
      ..add(ASN1Integer(sig.s));
    return seq.encode().toList();
  }

  List<int> getPublicKeyHash() {
    final keyBytes = getPublicKeyBytes();
    final digest = sha256.convert(keyBytes);
    return digest.bytes;
  }

  List<int> getPublicKeyBytes() {
    final algorithmSeq = ASN1Sequence();

    algorithmSeq.add(ASN1ObjectIdentifier.fromName('ecPublicKey'));
    algorithmSeq.add(ASN1ObjectIdentifier.fromName('prime256v1'));

    final publicKeyBytes = publicKey.Q!.getEncoded(false);

    final publicKeyBitString = ASN1BitString(stringValues: publicKeyBytes);

    final topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeyBitString);

    return topLevelSeq.encode().toList();
  }

  List<int> getPrivateKeyBytes() {
    const curveOid = "1.2.840.10045.3.1.7"; // prime256v1
    const algorithmOid = "1.2.840.10045.2.1"; // id-ecPublicKey

    final d = privateKey.d!;
    final bytes = d.toRadixString(16).padLeft(64, '0');
    final privateKeyBytes = Uint8List.fromList(
      List.generate(32, (i) =>
          int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16)),
    );

    // ===== ECPrivateKey structure =====
    final ecPrivateKeySeq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.from(1)))
      ..add(ASN1OctetString(octets: privateKeyBytes));

    // parameters [0] EXPLICIT OBJECT IDENTIFIER
    final curveObjectId =
    ASN1ObjectIdentifier.fromIdentifierString(curveOid);
    final curveEncoded = curveObjectId.encode();

    final taggedCurve = ASN1Object(
      tag: 0xA0
    )
    ..valueBytes = curveEncoded;

    ecPrivateKeySeq.add(taggedCurve);

    final ecPrivateKeyEncoded = ecPrivateKeySeq.encode();

    // ===== AlgorithmIdentifier =====
    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromIdentifierString(algorithmOid))
      ..add(ASN1ObjectIdentifier.fromIdentifierString(curveOid));

    // ===== PrivateKeyInfo (PKCS#8) =====
    final topLevelSeq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero))
      ..add(algorithmSeq)
      ..add(ASN1OctetString(octets: ecPrivateKeyEncoded));

    return topLevelSeq.encode().toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "publicKey": base64.encode(getPublicKeyBytes()),   // X.509
      "privateKey": base64.encode(getPrivateKeyBytes()) // PKCS#8
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientKey &&
        other.publicKey == publicKey &&
        other.privateKey == privateKey;
  }

  @override
  int get hashCode {
    return Object.hash(
      publicKey,
      privateKey
    );
  }

}