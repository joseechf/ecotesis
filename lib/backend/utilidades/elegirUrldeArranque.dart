/*
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'dart:io' show Platform;

String get baseUrl {
  // 1️⃣ Producción
  if (kReleaseMode) {
    return 'https://api.miapp.com';
  }

  // 2️⃣ Flutter Web
  if (kIsWeb) {
    return 'http://localhost:3001';
  }

  // 3️⃣ Android Emulator
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3001';
  }

  // 4️⃣ Dispositivo físico (Android / iOS)
  return 'http://192.168.0.11:3001';
}
*/
