import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'frond/static/home.dart';
import 'frond/estilos.dart';
import 'frond/baseDatos/providers/especies_provider.dart'; // bd falsa, cambiar después
import 'frond/admin/provider/admin_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      saveLocale: true,
      child: const AppLoader(),
    ),
  );
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    /*return ChangeNotifierProvider(
      create: (_) => EspeciesProvider(), // mientras uso bd falsa
      child: const MyApp(),
    );*/
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EspeciesProvider()),
        ChangeNotifierProvider(create: (_) => RegSiembraProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Estilos.tema,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MyHomePage(),
    );
  }
}
