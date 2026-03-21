import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'visorpdf.dart';

class Ecoguias extends StatelessWidget {
  const Ecoguias({super.key});
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double alturaPantalla = MediaQuery.of(context).size.height;

    final listaGuias = _obtenerListaGuias(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,
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
                  margin: EdgeInsets.symmetric(
                    vertical: anchoPantalla * 0.070,
                    horizontal: anchoPantalla * 0.070,
                  ),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        TextContainerWidget(
                          text: context.tr('texts.ecoguias.titulo'),
                          margin: const EdgeInsets.all(20),
                          padding: 0,
                          backgroundColor: Colors.transparent,
                          alignment: Alignment.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 4, 63, 19),
                            fontSize: anchoPantalla * 0.060,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextContainerWidget(
                          text: context.tr('texts.ecoguias.texto'),
                          margin: const EdgeInsets.all(20),
                          padding: 0,
                          backgroundColor: Colors.transparent,
                          alignment: Alignment.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 4, 63, 19),
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: List.generate(listaGuias.length, (index) {
                return ResponsiveLayout(
                  breakpoint: 400,
                  children: [
                    ImageContainerWidget(
                      imagePath: listaGuias[index]['imagen'],
                      margin: const EdgeInsets.all(10),
                      padding: 0,
                      height: 300,
                    ),
                    Column(
                      children: [
                        TextContainerWidget(
                          text: listaGuias[index]['titulo'],
                          margin: const EdgeInsets.all(20),
                          padding: 0,
                          backgroundColor: Colors.transparent,
                          alignment: Alignment.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 1, 43, 15),
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextContainerWidget(
                          text: listaGuias[index]['texto'],
                          margin: const EdgeInsets.all(20),
                          padding: 0,
                          backgroundColor: Colors.transparent,
                          alignment: Alignment.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 1, 43, 15),
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        listaGuias[index]['boton'],
                      ],
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 20),
            const Footer(),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _obtenerListaGuias(BuildContext context) {
    return [
      {
        "imagen": "assets/images/mirando.jpg",
        "titulo": "Fire Control: Rights & Regulations",
        "boton": ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(
              'https://www.proecoazuero.org/_files/ugd/e6eb07_1fd529ccb36744f7a1f475f2fa11796d.pdf',
            );

            if (kIsWeb) {
              await launchUrl(url, mode: LaunchMode.platformDefault);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisorPDF(url: url.toString()),
                ),
              );
            }
          },
          child: Text('Abrir PDF'),
        ),
        "texto": context.tr('texts.comunidad.recursoColaborador.texto1'),
      },
      {
        "imagen": "assets/images/mirando.jpg",
        "titulo": "Fire Control: Rights & Regulations",
        "boton": ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(
              'https://www.proecoazuero.org/_files/ugd/e6eb07_1fd529ccb36744f7a1f475f2fa11796d.pdf',
            );

            if (kIsWeb) {
              await launchUrl(url, mode: LaunchMode.platformDefault);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisorPDF(url: url.toString()),
                ),
              );
            }
          },
          child: Text('Abrir PDF'),
        ),
        "texto": context.tr('texts.comunidad.recursoColaborador.texto1'),
      },
    ];
  }
}
