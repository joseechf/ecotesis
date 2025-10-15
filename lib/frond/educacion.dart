import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'iureutilizables/widgetpersonalizados.dart';
import 'iureutilizables/custom_appbar.dart' as app_bar;

class Educacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double alturaPantalla = MediaQuery.of(context).size.height;
    final isMobile = anchoPantalla < 800;
    return Scaffold(
      appBar: customAppBar(context: context), 
      endDrawer: isMobile ? app_bar.MobileMenu() : null, // Agregar el Drawer solo para móvil
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
              WidgetPersonalizados.constructorContainerimg(
                'assets/images/casaVieja.jpg',
                0,
                0,
                400,
                0
              ),
              WidgetPersonalizados.constructorContainerText(
                context.tr('titles.titlePrincipal.educacion'),
                Colors.white,
                const Color.fromARGB(255, 3, 49, 13),
                EdgeInsets.all(0),
                0,
                (!isMobile)?100:50,
                'Oswald',
                FontWeight.bold,
                Alignment.center,
              ),

              WidgetPersonalizados.ElijeFilaColumnaDynamico([
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
                      child: WidgetPersonalizados.constructorContainerText(
                        context.tr('texts.educacion.monoArania'),
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(20),
                        20,
                        anchoPantalla*0.070,
                        'Oswald',
                        FontWeight.bold,
                        Alignment.center, // este puede ser redundante ahora
                      ),
                    ),
                  ],
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.educacion.texto1'),
                  const Color.fromARGB(0, 0, 0, 0),
                  const Color.fromARGB(255, 2, 49, 10),
                  EdgeInsets.only(left: 30,top: 10,right: 30,bottom: 10),
                  0,
                  20,
                  'Oswald',
                  FontWeight.w200,
                  Alignment.center,
                ),
              ], 400),

              WidgetPersonalizados.ElijeFilaColumnaDynamico([
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.educacion.objetivo.texto1'),
                  const Color.fromARGB(0, 20, 68, 6),
                  const Color.fromARGB(255, 20, 68, 6),
                  EdgeInsets.all(20),
                  10,
                  20,
                  'Oswald',
                  FontWeight.w200,
                  Alignment.center,
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.educacion.objetivo.texto2'),
                  const Color.fromARGB(0, 20, 68, 6),
                  const Color.fromARGB(255, 20, 68, 6),
                  EdgeInsets.all(20),
                  10,
                  20,
                  'Oswald',
                  FontWeight.w200,
                  Alignment.center,
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.educacion.objetivo.texto3'),
                  const Color.fromARGB(0, 20, 68, 6),
                  const Color.fromARGB(255, 20, 68, 6),
                  EdgeInsets.all(20),
                  10,
                  20,
                  'Oswald',
                  FontWeight.w200,
                  Alignment.center,
                ),
              ], 600),

              WidgetPersonalizados.constructorContainerText(
                'AQUI VAN IMAGENES',
                Colors.amber,
                Colors.blue,
                EdgeInsets.all(20),
                0,
                30,
                'Oswald',
                FontWeight.bold,
                Alignment.center,
              ),

              WidgetPersonalizados.ElijeFilaColumnaDynamico([
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
                      child: WidgetPersonalizados.constructorContainerText(
                        context.tr('texts.educacion.kids.title'),
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(20),
                        20,
                        anchoPantalla*0.070,
                        'Oswald',
                        FontWeight.bold,
                        Alignment.center, // este puede ser redundante ahora
                      ),
                    ),
                  ],
                ),
                WidgetPersonalizados.constructorContainerText(
                  context.tr('texts.educacion.kids.texto'),
                  const Color.fromARGB(0, 0, 0, 0),
                  const Color.fromARGB(255, 2, 49, 10),
                  EdgeInsets.only(left: 50,top:20, right: 50,bottom: 20),
                  0,
                  20,
                  'Oswald',
                  FontWeight.w200,
                  Alignment.center,
                ),
              ], alturaPantalla),

              WidgetPersonalizados.constructorContainerText(
                'AQUI VAN IMAGENES',
                Colors.amber,
                Colors.blue,
                EdgeInsets.all(0),
                0,
                30,
                'Oswald',
                FontWeight.bold,
                Alignment.center,
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}
