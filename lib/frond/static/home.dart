import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import 'conservrefor.dart';
import 'educacion.dart';
import 'comunidad.dart';
import '../iureutilizables/footer.dart';
import 'listas_lazy_loading/listas_lazy.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color fondo = const Color.fromARGB(0, 196, 230, 204);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SafeArea(
        child: ListView(
          children: [
            ImageContainerWidget(
              imagePath: 'assets/images/mono1.jpg',
              margin: EdgeInsets.zero,
              padding: 0,
              height: 400,
            ),

            LayoutBuilder(
              builder: (context, constraints) {
                double ancho = constraints.maxWidth * 0.090;
                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/bosque.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 400,
                          cacheWidth: 500,
                          cacheHeight: 500,
                        ),
                      ),
                      Center(
                        child: Text(
                          'PRO ECO AZUERO',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Oswald',
                            fontSize: ancho,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            TextContainerWidget(
              text: context.tr('texts.textsHome.texto1'),
              margin: EdgeInsets.all(20),
              padding: 10,
              backgroundColor: fondo,
              alignment: Alignment.center,
              style: TextStyle(
                color: Color.fromARGB(255, 18, 90, 5),
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w300,
              ),
            ),

            ResponsiveLayout(
              breakpoint: 400,
              children: [
                TextContainerWidget(
                  text: context.tr('texts.textsHome.esun'),
                  margin: EdgeInsets.all(20),
                  padding: 10,
                  backgroundColor: const Color.fromARGB(0, 253, 255, 254),
                  alignment: Alignment.centerLeft,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 20, 68, 6),
                    fontSize: 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ImageContainerWidget(
                  imagePath: 'assets/images/doñas.jpg',
                  margin: EdgeInsets.all(10),
                  padding: 10,
                  height: 400,
                ),
              ],
            ),

            ResponsiveLayout(
              breakpoint: 400,
              children: [
                ImageContainerWidget(
                  imagePath: 'assets/images/monoArania.jpg',
                  margin: EdgeInsets.all(20),
                  padding: 10,
                  height: 400,
                ),
                TextContainerWidget(
                  text: context.tr('texts.textsHome.monoArania'),
                  margin: EdgeInsets.all(10),
                  padding: 10,
                  backgroundColor: const Color.fromARGB(0, 253, 255, 254),
                  alignment: Alignment.centerLeft,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 20, 68, 6),
                    fontSize: 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Bloque cargando 1
            FutureBuilder<List<Map<String, String>>>(
              future: cargarListasHacemos(context),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error al cargar los datos');
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final listaHacemos = snapshot.data!;
                return Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      TextContainerWidget(
                        text: context.tr('titles.hacemos'),
                        margin: EdgeInsets.all(20),
                        padding: 10,
                        backgroundColor: fondo,
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 2, 63, 2),
                          fontSize: (!isMobile) ? 50 : 30,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(listaHacemos.length, (
                              index,
                            ) {
                              return Container(
                                margin:
                                    (!isMobile)
                                        ? EdgeInsets.all(20)
                                        : EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                width: 350,
                                height: 700,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    ListaWidgetOrdenada(
                                      datos: listaHacemos[index],
                                      radioImg: 0,
                                      onNavegar: (ctx, ruta) {
                                        final destino =
                                            {
                                              'conservacion': Conservrefor(),
                                              'educDiv': Educacion(),
                                              'colaboracion': Comunidad(),
                                            }[ruta];

                                        if (destino != null) {
                                          Navigator.pushAndRemoveUntil(
                                            ctx,
                                            MaterialPageRoute(
                                              builder: (_) => destino,
                                            ),
                                            (_) => false,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            TextContainerWidget(
              text: context.tr('texts.textsHome.NewYorkTimes'),
              margin: EdgeInsets.all(20),
              padding: 10,
              backgroundColor: const Color.fromARGB(0, 4, 66, 12),
              alignment: Alignment.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 58, 5),
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w300,
              ),
            ),
            TextContainerWidget(
              text: '- New York Times',
              margin: EdgeInsets.all(20),
              padding: 10,
              backgroundColor: const Color.fromARGB(0, 4, 66, 12),
              alignment: Alignment.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 58, 5),
                fontSize: 20,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w200,
              ),
            ),

            // Bloque cargando 2
            FutureBuilder<List<Map<String, String>>>(
              future: cargarlistaNoticias(context),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error al cargar los datos');
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final listaNoticias = snapshot.data!;
                return Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      TextContainerWidget(
                        text: context.tr('titles.noticias'),
                        margin: EdgeInsets.all(20),
                        padding: 10,
                        backgroundColor: fondo,
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 20, 56, 28),
                          fontSize: (!isMobile) ? 50 : 30,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(listaNoticias.length, (
                              index,
                            ) {
                              return Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(5),
                                width: 350,
                                height: 600,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    ListaWidgetOrdenada(
                                      datos: listaNoticias[index],
                                      radioImg: 0,
                                      onNavegar: (ctx, ruta) async {
                                        final uri = Uri.parse(ruta);

                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            ImageContainerWidget(
              imagePath: 'assets/images/manos.jpg',
              margin: EdgeInsets.zero,
              padding: 0,
              height: 400,
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
