import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'iureutilizables/widgetpersonalizados.dart';
import 'iureutilizables/custom_appbar.dart' as app_bar;

class Conservrefor extends StatelessWidget {

  Future<List<Map<String, String>>> _cargarListaIniciativas(
    BuildContext context,
  ) async {
    return [
      {
        'imagen': 'assets/images/doñas.jpg',
        'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.viveros'),
        'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.viveros'), 
      },
      {
        'imagen': 'assets/images/doñas.jpg',
        'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.Microproductores'),
        'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.Microproductores'),
      },
      {
        'imagen': 'assets/images/doñas.jpg',
        'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.semillas'),
        'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.semillas'),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: customAppBar(context: context),
      endDrawer: isMobile ? app_bar.MobileMenu() : null, // Agregar el Drawer solo para móvil
      body: SafeArea(
        child: ListView(
          //lazy loading
          //child: Column(
          children: [
            WidgetPersonalizados.constructorContainerimg(
              'assets/images/mono1.jpg',
              0,
              0,
              400,
              0
            ),

            LayoutBuilder(builder: (context, constraints){
              double ancho = constraints.maxWidth;
              double tamanioResponsive = ancho * 0.082;
              return Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 400),
              margin: EdgeInsets.only(bottom: 20),
              child: Stack(
                //fit: StackFit.expand,
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
            }),
            

            WidgetPersonalizados.ElijeFilaColumnaDynamico([
              WidgetPersonalizados.constructorContainerText(
                context.tr('texts.conservrefor.restHabit.title'),
                const Color.fromARGB(0, 20, 68, 6),
                const Color.fromARGB(255, 20, 68, 6),
                EdgeInsets.all(20),
                10,
                30,
                'Oswald',
                FontWeight.bold,
                Alignment.center,
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
            ], 400),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    color: const Color.fromARGB(255, 12, 61, 16),
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                   /* child: FittedBox(
                      fit: BoxFit.contain,*/
                      child: Text(
                      context.tr('titles.titlePrincipal.corredor'),
                      style: TextStyle(
                        fontSize: (!isMobile)
                          ? (screenWidth * 0.06).clamp(40.0, 60.0)
                          : 15,
                        color: Colors.white
                      ),
                    ),
                    //),
                    
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: WidgetPersonalizados.constructorContainerimg(
                    'assets/images/corredor.jpg',
                    0,
                    0,
                    400,
                    0
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('titles.cultivoSostenible'),
                    const Color.fromARGB(0, 20, 68, 6),
                    const Color.fromARGB(255, 20, 68, 6),
                    EdgeInsets.all(20),
                    10,
                    (!isMobile)? 50 : 30,
                    'Oswald',
                    FontWeight.bold,
                    Alignment.center,
                  ),
                  WidgetPersonalizados.constructorContainerText(
                    context.tr('texts.conservrefor.progInternos'),
                    const Color.fromARGB(0, 20, 68, 6),
                    const Color.fromARGB(255, 20, 68, 6),
                    EdgeInsets.all(20),
                    10,
                    20,
                    'Oswald',
                    FontWeight.w200,
                    Alignment.center,
                  ),
                  FutureBuilder<List<Map<String, String>>>(
                    future: _cargarListaIniciativas(context),
                    builder: (context, datos) {
                      if (datos.hasError) return Text('ERROR AL CARGAR LA SECCION');
                      if (!datos.hasData) return Text('SECCION VACIA');
                      final listaIniciativas = datos.data!;
                      return Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(listaIniciativas.length, (
                          index,
                        ) {
                          return Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(10),
                            width: 350,
                            height: 600,
                            child: WidgetPersonalizados.ListaWidgetOrdenada(
                              listaIniciativas[index],
                              100,
                              context
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),

            WidgetPersonalizados.constructorContainerText(
              context.tr('titles.pregFrecuentes'),
              const Color.fromARGB(0, 255, 255, 255),
              const Color.fromARGB(255, 3, 54, 11),
              EdgeInsets.all(20),
              20,
              (!isMobile)?120:30,
              'Oswald',
              FontWeight.bold,
              Alignment.center,
            ),

            Container(
              margin: (!isMobile)?EdgeInsets.all(50):EdgeInsets.all(10),
              child: WidgetPersonalizados.ElijeFilaColumnaDynamico([
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.preguntas.titulo'),
                  Colors.transparent,
                  Color.fromARGB(255, 20, 40, 20),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.04).clamp(32.0, 50.0) : 30,
                  'Oswald',
                  FontWeight.bold,
                  Alignment.center,
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.preguntas.texto'),
                  Colors.transparent,
                  Color.fromARGB(255, 40, 60, 40),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.02).clamp(18.0, 24.0) : 30,
                  'Oswald',
                  FontWeight.w300,
                  Alignment.center,
                ),
              ], 900),
            ),

            Container(
              margin: EdgeInsets.all(0),
              padding: (!isMobile)?EdgeInsets.all(50):EdgeInsets.all(10),
              child: WidgetPersonalizados.ElijeFilaColumnaDynamico([
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.beneficios.titulo'),
                  Colors.transparent,
                  Color.fromARGB(255, 60, 80, 60),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.04).clamp(32.0, 50.0) : 30,
                  'Oswald',
                  FontWeight.bold,
                  Alignment.center,
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.beneficios.texto'),
                  Colors.transparent,
                  Color.fromARGB(255, 80, 100, 80),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.02).clamp(18.0, 24.0) : 30,
                  'Oswald',
                  FontWeight.w300,
                  Alignment.center,
                ),
              ], 900),
            ),

            Container(
              margin: (!isMobile)?EdgeInsets.all(50):EdgeInsets.all(10),
              child: WidgetPersonalizados.ElijeFilaColumnaDynamico([
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.enfoque.titulo'),
                  Colors.transparent,
                  Color.fromARGB(255, 20, 40, 20),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.04).clamp(32.0, 50.0) : 30,
                  'Oswald',
                  FontWeight.bold,
                  Alignment.center,
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.conservrefor.enfoque.texto'),
                  Colors.transparent,
                  Color.fromARGB(255, 40, 60, 40),
                  EdgeInsets.all(20),
                  10,
                  (!isMobile)? (screenWidth * 0.02).clamp(18.0, 24.0) : 30,
                  'Oswald',
                  FontWeight.w300,
                  Alignment.center,
                ),
              ], 900),
            ),

            WidgetPersonalizados.constructorContainerimg(
              'assets/images/mirando.jpg',
              0,
              0,
              400,
              0
            ),

            WidgetPersonalizados.constructorContainerText(
              context.tr('texts.conservrefor.Patrick_Leung.texto'),
              const Color.fromARGB(0, 0, 0, 0),
              const Color.fromARGB(255, 5, 46, 5),
              EdgeInsets.all(10),
              10,
              30,
              'Oswald',
              FontWeight.w400,
              Alignment.center,
            ),
            WidgetPersonalizados.constructorContainerText(
              context.tr('texts.conservrefor.Patrick_Leung.autor'),
              const Color.fromARGB(0, 0, 0, 0),
              const Color.fromARGB(255, 5, 46, 5),
              EdgeInsets.all(10),
              10,
              (!isMobile)?30:15,
              'Oswald',
              FontWeight.w200,
              Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
