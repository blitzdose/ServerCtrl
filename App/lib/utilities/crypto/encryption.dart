import 'dart:convert';
import 'dart:math';

class Encryption {
  static String generateEncryptionKey() {
    Random random;
    try {
      random = Random.secure();
    } on UnsupportedError catch (_) {
      random = Random();
    }

    var values = List<int>.generate(64, (i) => random.nextInt(256));
    return base64Encode(values);
  }
}