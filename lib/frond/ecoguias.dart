import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'visorpdf.dart';
import 'iureutilizables/custom_appbar.dart' as app_bar;

class Ecoguias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double alturaPantalla = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar(context: context),
      endDrawer: anchoPantalla < 800 ? app_bar.MobileMenu() : null,
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/mono1.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: alturaPantalla,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: anchoPantalla * 0.070,
                    bottom: anchoPantalla * 0.070,
                    left: anchoPantalla * 0.070,
                    right: anchoPantalla * 0.070,
                  ),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Column(
                      children: [
                        WidgetPersonalizados.constructorContainerText(
                          context.tr('texts.ecoguias.titulo'),
                          const Color.fromARGB(0, 255, 35, 35),
                          const Color.fromARGB(255, 4, 63, 19),
                          EdgeInsets.all(20),
                          0,
                          anchoPantalla * 0.060,
                          'Oswald',
                          FontWeight.w500,
                          Alignment.center,
                        ),
                        WidgetPersonalizados.constructorContainerText(
                          context.tr('texts.ecoguias.texto'),
                          const Color.fromARGB(0, 46, 255, 39),
                          const Color.fromARGB(255, 4, 63, 19),
                          EdgeInsets.all(20),
                          0,
                          20,
                          'Oswald',
                          FontWeight.w200,
                          Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _obtenerListaGuias(context),
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
                final listaGuias = snapshot.data!;
                return Column(
                  children: List.generate(listaGuias.length, (index) {
                    return WidgetPersonalizados.ElijeFilaColumnaDynamico([
                      WidgetPersonalizados.constructorContainerimg(
                        listaGuias[index]['imagen'],
                        10,
                        0,
                        300,
                        0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            WidgetPersonalizados.constructorContainerText(
                              listaGuias[index]['titulo'],
                              const Color.fromARGB(0, 255, 255, 255),
                              const Color.fromARGB(255, 1, 43, 15),
                              EdgeInsets.all(20),
                              0,
                              20,
                              'Oswald',
                              FontWeight.bold,
                              Alignment.center,
                            ),
                            WidgetPersonalizados.constructorContainerText(
                              listaGuias[index]['texto'],
                              const Color.fromARGB(0, 255, 255, 255),
                              const Color.fromARGB(255, 1, 43, 15),
                              EdgeInsets.all(20),
                              0,
                              20,
                              'Oswald',
                              FontWeight.bold,
                              Alignment.center,
                            ),
                            listaGuias[index]['boton'],
                          ],
                        ),
                      ),
                    ], 400);
                  }),
                );
              },
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _obtenerListaGuias(
    BuildContext context,
  ) async {
    return [
      {
        "imagen": "assets/images/mirando.jpg",
        "titulo": "Fire Control: Rights & Regulations",
        "boton": ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => VisorPDF(
                      url:
                          'https://www.proecoazuero.org/_files/ugd/e6eb07_1fd529ccb36744f7a1f475f2fa11796d.pdf',
                    ),
              ),
            );
          },
          child: Text('Abrir PDF'),
        ),
        "texto": context.tr('texts.comunidad.recursoColaborador.texto1'),
      },
      {
        "imagen": "assets/images/mirando.jpg",
        "titulo": "Fire Control: Rights & Regulations",
        "boton": ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => VisorPDF(
                      url:
                          'https://www.proecoazuero.org/_files/ugd/e6eb07_1fd529ccb36744f7a1f475f2fa11796d.pdf',
                    ),
              ),
            );
          },
          child: Text('Abrir PDF'),
        ),
        "texto": context.tr('texts.comunidad.recursoColaborador.texto1'),
      },
    ];
  }
}
