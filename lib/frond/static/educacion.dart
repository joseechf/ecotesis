import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';

class Educacion extends StatelessWidget {
  const Educacion({super.key});
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    final isMobile = anchoPantalla < 800;
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
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),
                ImageContainerWidget(
                  imagePath: 'assets/images/casaVieja.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),
                TextContainerWidget(
                  text: context.tr('titles.titlePrincipal.educacion'),
                  margin: EdgeInsets.all(0),
                  padding: 0,
                  backgroundColor: Colors.white,
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 3, 49, 13),
                    fontSize: (!isMobile) ? 100 : 50,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ResponsiveLayout(
                  breakpoint: 400,
                  children: [
                    Stack(
                      children: [
                        Align(
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/bosque.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (context) {
                              return TextContainerWidget(
                                text: context.tr('texts.educacion.monoArania'),
                                margin: EdgeInsets.all(20),
                                padding: 20,
                                backgroundColor: const Color.fromARGB(
                                  0,
                                  255,
                                  255,
                                  255,
                                ),
                                alignment: Alignment.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: anchoPantalla * 0.070,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    TextContainerWidget(
                      text: context.tr('texts.educacion.texto1'),
                      margin: EdgeInsets.only(
                        left: 30,
                        top: 10,
                        right: 30,
                        bottom: 10,
                      ),
                      padding: 0,
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 2, 49, 10),
                        fontSize: 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),

                ResponsiveLayout(
                  breakpoint: 600,
                  children: [
                    TextContainerWidget(
                      text: context.tr('texts.educacion.objetivo.texto1'),
                      margin: EdgeInsets.all(20),
                      padding: 10,
                      backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 32, 1),
                        fontSize: 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    TextContainerWidget(
                      text: context.tr('texts.educacion.objetivo.texto2'),
                      margin: EdgeInsets.all(20),
                      padding: 10,
                      backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 32, 1),
                        fontSize: 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    TextContainerWidget(
                      text: context.tr('texts.educacion.objetivo.texto3'),
                      margin: EdgeInsets.all(20),
                      padding: 10,
                      backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 32, 1),
                        fontSize: 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),

                TextContainerWidget(
                  text: 'AQUI VAN IMAGENES',
                  margin: EdgeInsets.all(20),
                  padding: 0,
                  backgroundColor: Colors.amber,
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ResponsiveLayout(
                  breakpoint: 600,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/bosque.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (context) {
                              return TextContainerWidget(
                                text: context.tr('texts.educacion.kids.title'),
                                margin: EdgeInsets.all(20),
                                padding: 20,
                                backgroundColor: const Color.fromARGB(
                                  0,
                                  255,
                                  255,
                                  255,
                                ),
                                alignment: Alignment.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: anchoPantalla * 0.070,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    TextContainerWidget(
                      text: context.tr('texts.educacion.kids.texto'),
                      margin: EdgeInsets.only(
                        left: 50,
                        top: 20,
                        right: 50,
                        bottom: 20,
                      ),
                      padding: 0,
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      alignment: Alignment.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 2, 49, 10),
                        fontSize: 20,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),

                TextContainerWidget(
                  text: 'AQUI VAN IMAGENES',
                  margin: EdgeInsets.all(0),
                  padding: 0,
                  backgroundColor: Colors.amber,
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Footer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
