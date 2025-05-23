import 'package:ecoazuero/frond/nosotros.dart';
import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'amplify_outputs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await _configureAmplify(); // Configura Amplify
  } on AmplifyException catch (e) {
    // Si falla Amplify, sigue cargando la app pero mostrando un mensaje
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text("Error configuring Amplify: ${e.message}")),
        ),
      ),
    );
    return;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(
      amplifyConfig,
    ); // <-- asegúrate de importar amplifyconfiguration.dart
    safePrint('Amplify configured successfully');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 24, 42, 1),
        ),
      ),
      //idioma
      debugShowCheckedModeBanner: false,
      title: context.tr('titles.title'), 
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: customAppBar(
            context: context,
          ), 
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity, //ancho completo
                    constraints: BoxConstraints(
                      maxHeight: 400,
                    ),
                    color: const Color.fromARGB(255, 24, 190, 29),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/mono1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 400,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: Image.asset('assets/images/bosque.jpg'),
                        ),

                        Center(
                          child: Text(
                            'PRO ECO AZUERO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 235, 240, 235),
                    padding: EdgeInsets.all(16), // Espacio interno,
                    alignment: Alignment.center,
                    child: Text(
                      context.tr('texts.texto1'),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        height: 1.5, // Espaciado entre líneas
                        color: Color.fromARGB(255, 18, 90, 5),
                      ),
                      textAlign:
                          TextAlign
                              .center, // Justificar el texto (alineado a ambos lados)
                    ),
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            Expanded(
                              child: _constructorContainer(context.tr('texts.esun')),
                            ),
                            Expanded(
                              child: _constructorContainerimg(
                                'assets/images/doñas.jpg',
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _constructorContainer(context.tr('texts.esun')),
                            _constructorContainerimg('assets/images/doñas.jpg'),
                          ],
                        );
                      }
                    },
                  ),

                  // Cuadro 2: Texto que ocupa otro 30% del alto
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      //minHeight: ResponsiveWrapper.of(context).isMobile ? 200 : 300,
                      maxHeight: 400,
                    ),
                    color: Colors.green[100],
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp(),
                                    ), // Navega a la segunda pantalla
                                  );
                                },
                                child: Text('Pro Eco Azuero'),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Nosotros(),
                              ), // Navega a la segunda pantalla
                            );
                          },
                          child: Text('Quienes somos'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 200,
                          color: Colors.amber,
                          alignment: Alignment.center,
                          child: Text("renglon 3 c-1"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 200,
                          color: Colors.brown,
                          alignment: Alignment.center,
                          child: Text("renglon 3 c-2"),
                        ),
                      ),
                    ],
                  ),
                  // Cuadro 3: Texto que ocupa otro 30% del alto
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      // minHeight: ResponsiveWrapper.of(context).isMobile ? 200 : 300,
                      maxHeight: 400,
                    ),
                    color: Colors.green[100],
                    alignment: Alignment.center,
                    child: const Text(
                      'Cuadro 2 - Texto centrado',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _constructorContainer(String text) {
    //container en columna
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromARGB(255, 27, 84, 28),
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _constructorContainerimg(String text) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Image.asset(
        text,
        fit: BoxFit.cover,
        width: double.infinity,
        height:
            200, // Fija una altura para evitar que se expanda ilimitadamente
      ),
    );
  }
}
