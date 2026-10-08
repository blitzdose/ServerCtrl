import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  static Future<File> createFile(String fileName) async {
    Directory storageDir;

    if (Platform.isAndroid) {
      storageDir = await getExternalStorageDirectory() ?? await getApplicationSupportDirectory();
    } else if (Platform.isIOS || Platform.isWindows) {
      storageDir = await getApplicationSupportDirectory();
    } else {
      storageDir = await getApplicationDocumentsDirectory();
    }

    final file = File('${storageDir.path}/$fileName');

    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    return file;
  }

  static String getRandomFilename({String? extension}) {
    final Random random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    final randomHex = base64Url.encode(values).replaceAll('=', '').replaceAll('-', '');
    return 'temp_$randomHex${extension == null ? '' : ".$extension"}';
  }
}