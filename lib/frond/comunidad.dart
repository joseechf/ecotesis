import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class Comunidad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double alturaPantalla = MediaQuery.of(context).size.height;
    bool isMobile = anchoPantalla < 800;
    return Scaffold(
      appBar: customAppBar(context: context),
      endDrawer: isMobile ? MobileMenu() : null, // Agregar el Drawer solo para móvil
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/mono1.jpg',
                  0,
                  0,
                  400,
                  0
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
                            fontSize: (!isMobile)?70:40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/mirando.jpg',
                  0,
                  0,
                  400,
                  0
                ),

                WidgetPersonalizados.ElijeFilaColumnaDynamico([
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('texts.comunidad.comites.titulo'),
                    const Color.fromARGB(255, 3, 53, 7),
                    Colors.white,
                    EdgeInsets.all(20),
                    20,
                    anchoPantalla * 0.050,
                    'Oswald',
                    FontWeight.bold,
                    Alignment.center,
                  ),
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('texts.comunidad.comites.texto'),
                    const Color.fromARGB(255, 255, 255, 255),
                    const Color.fromARGB(255, 2, 56, 14),
                    (!isMobile)?EdgeInsets.all(50):EdgeInsets.all(10),
                    20,
                    (!isMobile)?30:20,
                    'Oswald',
                    FontWeight.w200,
                    Alignment.center,
                  ),
                ], alturaPantalla),

                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/mirando.jpg',
                  0,
                  0,
                  400,
                  0
                ),

                WidgetPersonalizados.ElijeFilaColumnaDynamico([
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('texts.comunidad.instituciones.titulo'),
                    const Color.fromARGB(255, 3, 53, 7),
                    Colors.white,
                    EdgeInsets.all(50),
                    20,
                    30,
                    'Oswald',
                    FontWeight.bold,
                    Alignment.center,
                  ),
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('texts.comunidad.instituciones.texto'),
                    const Color.fromARGB(255, 255, 255, 255),
                    const Color.fromARGB(255, 2, 56, 14),
                    EdgeInsets.all(20),
                    20,
                    30,
                    'Oswald',
                    FontWeight.w200,
                    Alignment.center,
                  ),
                ], 600),

                FutureBuilder<List<Map<String, String>>>(
                  future: _obtenerRecursosColaboradores(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error al cargar los datos');
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
                      color: const Color.fromARGB(255, 132, 218, 167),
                      child: Column(
                        children: [
                          WidgetPersonalizados.constructorContainerText(
                            context.tr(
                              'texts.comunidad.recursoColaborador.titulo',
                            ),
                            const Color.fromARGB(0, 0, 0, 0),
                            const Color.fromARGB(255, 253, 253, 253),
                            EdgeInsets.all(20),
                            10,
                            50,
                            'Oswald',
                            FontWeight.bold,
                            Alignment.center,
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
                                      height: maxTextHeight + 100, // Añadir espacio para el icono y padding
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
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
                                              child: WidgetPersonalizados.constructorContainerText(
                                                listaRecursosColaboradores[index]['texto']!,
                                                Colors.white,
                                                const Color.fromARGB(255, 4, 46, 4),
                                                EdgeInsets.all(10),
                                                10,
                                                20,
                                                'Oswald',
                                                FontWeight.w200,
                                                Alignment.center,
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
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
                const CustomFooter(),
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
