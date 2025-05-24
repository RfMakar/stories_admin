import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> assetToFile(String assetPath, String fileName) async {
  // 1. Загрузить bytes из assets
  final byteData = await rootBundle.load(assetPath);

  // 2. Получить временную директорию приложения
  final tempDir = await getTemporaryDirectory();

  // 3. Создать файл с нужным именем
  final file = File('${tempDir.path}/$fileName');

  // 4. Записать bytes в файл
  await file.writeAsBytes(byteData.buffer.asUint8List());

  return file;
}