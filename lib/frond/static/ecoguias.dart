import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/footer.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'visorpdf.dart';
import 'listas_dinamicas/listas_dinamicas.dart';
import '../estilos.dart';

class Ecoguias extends StatelessWidget {
  const Ecoguias({super.key});
  @override  
  Widget build(BuildContext context){
    double anchoPantalla = MediaQuery.of(context).size.width;
    double alturaPantalla = MediaQuery.of(context).size.height;

    final isMobil = anchoPantalla < Estilos.cambioMenu;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobil ? const MobileMenu() : null,
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
                              fontSize:  anchoPantalla * 0.060,
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
                              fontSize:  20,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            FutureBuilder<List<Map<String, String>>>(
                future: cargarGuias(context),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Text('Error al cargar los datos');
                  }
                  if(!snapshot.hasData){
                    return const Center(
                      child: Padding(padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final lista = snapshot.data!;
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(lista.length, (index){
                      final datos = lista[index];
                      datos['boton'] = context.tr(datos['pdfkey'].toString());
                      return SizedBox(
                        width: 350,
                        child: ListaWidgetOrdenada(
                          datos: datos, 
                          radioImg: 10,
                          onNavegar: (ctx, ruta) async {
                            final url = Uri.parse(ruta.trim());

                            if(kIsWeb){
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }else{
                              Navigator.push(ctx,MaterialPageRoute(
                                builder: (_) => VisorPDF(url: url.toString())));
                            }
                          },
                        ),
                      );
                    }),
                  );
                },
              ),
              SizedBox(height: 20,),
              const Footer(),
          ],
        ),
      ),
    );
    
  }
}