import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import '../iureutilizables/footer.dart';

class Nosotros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: customAppBar(context: context),
          drawer:
              MediaQuery.sizeOf(context).width < 800
                  ? const MobileMenu()
                  : null,
          body: SafeArea(
            child: ListView(
              //child: Column(
              children: [
                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/mono1.jpg',
                  0,
                  0,
                  400,
                  0,
                ),

                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Stack(
                    //fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/bosque.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Center(
                        child: Text(
                          context.tr('titles.titlePrincipal.nosotros'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        children: [
                          Expanded(
                            child: WidgetPersonalizados.constructorContainerimg(
                              'assets/images/bosque.jpg',
                              20,
                              10,
                              400,
                              0,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
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
                                            'texts.textsNosotros.historia.p1',
                                          ),
                                        ),
                                        TextSpan(
                                          text: context.tr(
                                            'texts.textsNosotros.historia.negrita',
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        TextSpan(
                                          text: context.tr(
                                            'texts.textsNosotros.historia.p2',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          WidgetPersonalizados.constructorContainerimg(
                            'assets/images/bosque.jpg',
                            20,
                            10,
                            400,
                            0,
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
                                      'texts.textsNosotros.historia.p1',
                                    ),
                                  ),
                                  TextSpan(
                                    text: context.tr(
                                      'texts.textsNosotros.historia.negrita',
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: context.tr(
                                      'texts.textsNosotros.historia.p2',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/casaVieja.jpg',
                  0,
                  0,
                  400,
                  0,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 4, 56, 13),
                  child: Column(
                    children: [
                      WidgetPersonalizados.constructorContainerText(
                        'Jay Chiat Centro de Aprendizaje Ambiental',
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(10),
                        10,
                        (!isMobile) ? 50 : 30,
                        'Oswald',
                        FontWeight.bold,
                        Alignment.center,
                      ),
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('texts.textsNosotros.aprendizaje'),
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(10),
                        10,
                        (!isMobile) ? 40 : 20,
                        'Oswald',
                        FontWeight.normal,
                        Alignment.center,
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    context.tr('titles.titlePrincipal.equipo'),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 8, 66, 13),
                    ),
                  ),
                ),

                WidgetPersonalizados.constructorContainerimg(
                  'assets/images/mono1.jpg',
                  0,
                  0,
                  400,
                  0,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 4, 56, 13),
                  child: Column(
                    children: [
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('titles.charrito'),
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(10),
                        10,
                        25,
                        'Oswald',
                        FontWeight.bold,
                        Alignment.center,
                      ),
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('texts.textsNosotros.charrito'),
                        const Color.fromARGB(0, 255, 255, 255),
                        Colors.white,
                        EdgeInsets.all(10),
                        10,
                        (!isMobile) ? 40 : 20,
                        'Oswald',
                        FontWeight.normal,
                        Alignment.center,
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('titles.titlePrincipal.PARTNERS'),
                        const Color.fromARGB(0, 255, 255, 255),
                        const Color.fromARGB(255, 8, 66, 25),
                        EdgeInsets.all(10),
                        10,
                        25,
                        'Oswald',
                        FontWeight.bold,
                        Alignment.center,
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
              //),
            ),
          ),
        );
      },
    );
  }
}
