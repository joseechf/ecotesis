import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'dart:io' show Platform;

String get baseUrl {
  // 1. Producción
  if (kReleaseMode) return 'https://api.miapp.com';
  //web
  if (kIsWeb) return 'http://localhost:3001';
  // 5. pruebas en dispositivo físico (Android/iOS) → IP de la pc
  return 'http://192.168.0.11:3001';
}
