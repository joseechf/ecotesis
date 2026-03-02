import 'package:ecoazuero/frond/estilos.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Comunidad extends StatelessWidget {
  const Comunidad({super.key});
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    bool isMobile = anchoPantalla < 800;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                ImageContainerWidget(
                  imagePath: 'assets/images/mono1.jpg',
                  margin: const EdgeInsets.all(0),
                  padding: 0,
                  height: 0,
                ),

                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mirando.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 400,
                          cacheWidth: 500, //resolucion guardada en memoria
                          cacheHeight: 500,
                        ),
                      ),
                      Center(
                        child: Text(
                          context.tr('titles.titlePrincipal.comunidad'),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Oswald',
                            fontSize: (!isMobile) ? 70 : 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ImageContainerWidget(
                  imagePath: 'assets/images/mirando.jpg',
                  margin: const EdgeInsets.all(0),
                  padding: 0,
                  height: 400,
                ),

                ResponsiveLayout(
                  breakpoint: 900,
                  children: [
                    TextContainerWidget(
                      text: context.tr('texts.comunidad.comites.titulo'),
                      margin: EdgeInsets.all(20),
                      padding: 20,
                      backgroundColor: const Color.fromARGB(255, 3, 53, 7),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: anchoPantalla * 0.050,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextContainerWidget(
                      text: context.tr('texts.comunidad.comites.texto'),
                      margin:
                          (!isMobile) ? EdgeInsets.all(50) : EdgeInsets.all(10),
                      padding: 20,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 2, 56, 14),
                        fontSize: (!isMobile) ? 30 : 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),

                ImageContainerWidget(
                  imagePath: 'assets/images/mirando.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),

                ResponsiveLayout(
                  breakpoint: 900,
                  children: [
                    TextContainerWidget(
                      text: context.tr('texts.comunidad.instituciones.titulo'),
                      margin: const EdgeInsets.all(50),
                      padding: 20,
                      backgroundColor: const Color.fromARGB(255, 3, 53, 7),
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    TextContainerWidget(
                      text: context.tr('texts.comunidad.instituciones.texto'),
                      margin: const EdgeInsets.all(20),
                      padding: 20,
                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                        color: Estilos.verdeOscuro,
                      ),
                    ),
                  ],
                ),

                FutureBuilder<List<Map<String, String>>>(
                  future: _obtenerRecursosColaboradores(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error al cargar los datos');
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final listaRecursosColaboradores = snapshot.data!;

                    return Container(
                      color: Estilos.verdeClaro,
                      child: Column(
                        children: [
                          TextContainerWidget(
                            text: context.tr(
                              'texts.comunidad.recursoColaborador.titulo',
                            ),
                            margin: const EdgeInsets.all(20),
                            padding: 10,
                            backgroundColor: Colors.transparent,
                            alignment: Alignment.center,
                            style: const TextStyle(
                              fontSize: 50,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold,
                              color: Estilos.blanco,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1500),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 20,
                                runSpacing: 20,
                                children: List.generate(
                                  listaRecursosColaboradores.length,
                                  (index) {
                                    final item =
                                        listaRecursosColaboradores[index];

                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(20),
                                      width: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.home,
                                            size: 40,
                                            color: Color.fromARGB(
                                              255,
                                              4,
                                              46,
                                              4,
                                            ),
                                          ),

                                          const SizedBox(height: 15),

                                          TextContainerWidget(
                                            text: item['texto']!,
                                            margin: EdgeInsets.zero,
                                            padding: 0,
                                            alignment: Alignment.topCenter,
                                            backgroundColor: Colors.white,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w200,
                                              color: Color.fromARGB(
                                                255,
                                                4,
                                                46,
                                                4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Footer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, String>>> _obtenerRecursosColaboradores(
    BuildContext context,
  ) async {
    return [
      {"texto": context.tr('texts.comunidad.recursoColaborador.texto1')},
      {"texto": context.tr('texts.comunidad.recursoColaborador.texto2')},
      {"texto": context.tr('texts.comunidad.recursoColaborador.texto3')},
      {"texto": context.tr('texts.comunidad.recursoColaborador.texto4')},
    ];
  }
}
