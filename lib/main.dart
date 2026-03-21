import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'frond/static/home.dart';
import 'frond/estilos.dart';
import 'frond/base_datos/providers/especies_provider.dart';
//import 'frond/admin/provider/admin_providers.dart';
import 'data/auth/session_provider.dart';
import 'data/auth/auth_admin_provider.dart';
import 'core/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  await SupabaseClientSingleton.init();

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

class AppLoader extends StatefulWidget {
  final bool disableSessionInit; // si estoy en test
  const AppLoader({super.key, this.disableSessionInit = false});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late final SessionProvider _sessionProvider;
  @override
  void initState() {
    super.initState();
    _sessionProvider = SessionProvider();

    if (!widget.disableSessionInit) {
      // si no estoy en test inicializo supabase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sessionProvider.init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _sessionProvider),
        ChangeNotifierProvider(create: (_) => AuthAdminProvider()),
        ChangeNotifierProvider(create: (_) => EspeciesProvider()),
        //ChangeNotifierProvider(create: (_) => RegSiembraProvider()),
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
