import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import '../estilos.dart';
import 'listas_lazy_loading/listas_lazy.dart';

class Conservrefor extends StatelessWidget {
  const Conservrefor({super.key});

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
                double ancho = constraints.maxWidth;
                double tamanioResponsive = ancho * 0.082;
                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/manos.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Center(
                        child: Text(
                          context.tr('titles.titlePrincipal.conservrefor'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: tamanioResponsive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            ResponsiveLayout(
              breakpoint: 600,
              children: [
                TextContainerWidget(
                  text: context.tr('texts.conservrefor.restHabit.title'),
                  margin: EdgeInsets.all(20),
                  padding: 10,
                  backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 20, 68, 6),
                    fontSize: 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: context.tr(
                            'texts.conservrefor.restHabit.text.p1',
                          ),
                        ),
                        TextSpan(
                          text: context.tr(
                            'texts.conservrefor.restHabit.text.negrita',
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: context.tr(
                            'texts.conservrefor.restHabit.text.p2',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            ResponsiveLayout(
              breakpoint: 800,
              children: [
                SizedBox(
                  height: 400,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ancho = constraints.maxWidth;

                      final fontSize = (ancho * 0.15).clamp(22.0, 60.0);

                      return Container(
                        color: Estilos.verdeOscuro,
                        alignment: Alignment.center,
                        child: TextContainerWidget(
                          text: context.tr('titles.titlePrincipal.corredor'),
                          margin: EdgeInsets.zero,
                          padding: 20,
                          alignment: Alignment.center,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ImageContainerWidget(
                  imagePath: 'assets/images/corredor.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),
              ],
            ),

            Column(
              children: [
                TextContainerWidget(
                  text: context.tr('titles.cultivoSostenible'),
                  margin: EdgeInsets.all(20),
                  padding: 10,
                  backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 20, 68, 6),
                    fontSize: (!isMobile) ? 50 : 30,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextContainerWidget(
                  text: context.tr('texts.conservrefor.progInternos'),
                  margin: EdgeInsets.all(20),
                  padding: 10,
                  backgroundColor: const Color.fromARGB(0, 20, 68, 6),
                  alignment: Alignment.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 20, 68, 6),
                    fontSize: 20,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                FutureBuilder<List<Map<String, String>>>(
                  future: cargarListaIniciativas(context),
                  builder: (context, datos) {
                    if (datos.hasError) {
                      return Text('ERROR AL CARGAR LA SECCION');
                    }
                    if (!datos.hasData) {
                      return Text('SECCION VACIA');
                    }
                    final listaIniciativas = datos.data!;
                    return Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: List.generate(listaIniciativas.length, (index) {
                        return Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          width: 350,
                          height: 600,
                          child: ListaWidgetOrdenada(
                            datos: listaIniciativas[index],
                            radioImg: 100,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),

            TextContainerWidget(
              text: context.tr('titles.pregFrecuentes'),
              margin: EdgeInsets.all(20),
              padding: 20,
              backgroundColor: const Color.fromARGB(0, 255, 255, 255),
              alignment: Alignment.center,
              style: TextStyle(
                color: Estilos.verdeOscuro,
                fontSize: (!isMobile) ? 120 : 30,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              margin: (!isMobile) ? EdgeInsets.all(50) : EdgeInsets.all(10),
              child: ResponsiveLayout(
                breakpoint: 900,
                children: [
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.preguntas.titulo'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 40, 20),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.04).clamp(32.0, 50.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.preguntas.texto'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 60, 40),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.02).clamp(18.0, 24.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(0),
              padding: (!isMobile) ? EdgeInsets.all(50) : EdgeInsets.all(10),
              child: ResponsiveLayout(
                breakpoint: 900,
                children: [
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.beneficios.titulo'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 4, 88, 4),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.04).clamp(32.0, 50.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.beneficios.texto'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 4, 88, 4),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.02).clamp(18.0, 24.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: (!isMobile) ? EdgeInsets.all(50) : EdgeInsets.all(10),
              child: ResponsiveLayout(
                breakpoint: 900,
                children: [
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.enfoque.titulo'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 40, 20),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.04).clamp(32.0, 50.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextContainerWidget(
                    text: context.tr('texts.conservrefor.enfoque.texto'),
                    margin: EdgeInsets.all(20),
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 60, 40),
                      fontSize:
                          (!isMobile)
                              ? (screenWidth * 0.02).clamp(18.0, 24.0)
                              : 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            ImageContainerWidget(
              imagePath: 'assets/images/mirando.jpg',
              margin: EdgeInsets.zero,
              padding: 0,
              height: 400,
            ),

            TextContainerWidget(
              text: context.tr('texts.conservrefor.Patrick_Leung.texto'),
              margin: EdgeInsets.all(10),
              padding: 10,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              alignment: Alignment.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 46, 5),
                fontSize: 30,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w400,
              ),
            ),

            TextContainerWidget(
              text: context.tr('texts.conservrefor.Patrick_Leung.autor'),
              margin: EdgeInsets.all(10),
              padding: 10,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              alignment: Alignment.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 46, 5),
                fontSize: (!isMobile) ? 30 : 15,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w200,
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
