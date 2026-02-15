import 'package:ecoazuero/frond/estilos.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

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
                  breakpoint:
                      600, // o el valor que prefieras para el breakpoint
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
                  breakpoint: 600,
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
                      return Text('Error al cargar los datos');
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

                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Encontrar el texto más largo para determinar la altura
                              double maxTextHeight = 0;
                              for (var item in listaRecursosColaboradores) {
                                final textSpan = TextSpan(
                                  text: item['texto'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w200,
                                  ),
                                );
                                final tp = TextPainter(
                                  text: textSpan,
                                  maxLines: 10,
                                  textDirection: ui.TextDirection.ltr,
                                );
                                tp.layout(maxWidth: 380); // 400 - padding
                                if (tp.height > maxTextHeight) {
                                  maxTextHeight = tp.height;
                                }
                              }

                              return Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: List.generate(
                                  listaRecursosColaboradores.length,
                                  (index) {
                                    return Container(
                                      margin: EdgeInsets.all(20),
                                      padding: EdgeInsets.all(5),
                                      width: 400,
                                      height:
                                          maxTextHeight +
                                          100, // Añadir espacio para el icono y padding
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.home,
                                            size: 40,
                                            color: const Color.fromARGB(
                                              255,
                                              4,
                                              46,
                                              4,
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: TextContainerWidget(
                                                text:
                                                    listaRecursosColaboradores[index]['texto']!,
                                                margin: const EdgeInsets.all(
                                                  10,
                                                ),
                                                padding: 10,
                                                backgroundColor: Colors.white,
                                                alignment: Alignment.center,
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
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
