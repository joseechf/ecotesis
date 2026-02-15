import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import '../iureutilizables/footer.dart';

class Nosotros extends StatelessWidget {
  const Nosotros({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: CustomAppBar(context: context),
          drawer:
              MediaQuery.sizeOf(context).width < 800
                  ? const MobileMenu()
                  : null,
          body: SafeArea(
            child: ListView(
              children: [
                ImageContainerWidget(
                  imagePath: 'assets/images/mono1.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),

                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Stack(
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

                ResponsiveLayout(
                  breakpoint: 600,
                  children: [
                    ImageContainerWidget(
                      imagePath: 'assets/images/bosque.jpg',
                      margin: EdgeInsets.all(20),
                      padding: 10,
                      height: 400,
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
                ),

                ImageContainerWidget(
                  imagePath: 'assets/images/casaVieja.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 4, 56, 13),
                  child: Column(
                    children: [
                      TextContainerWidget(
                        text: 'Jay Chiat Centro de Aprendizaje Ambiental',
                        margin: EdgeInsets.all(10),
                        padding: 10,
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (!isMobile) ? 50 : 30,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextContainerWidget(
                        text: context.tr('texts.textsNosotros.aprendizaje'),
                        margin: EdgeInsets.all(10),
                        padding: 10,
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (!isMobile) ? 40 : 20,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.normal,
                        ),
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

                ImageContainerWidget(
                  imagePath: 'assets/images/mono1.jpg',
                  margin: EdgeInsets.zero,
                  padding: 0,
                  height: 400,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  color: const Color.fromARGB(255, 4, 56, 13),
                  child: Column(
                    children: [
                      TextContainerWidget(
                        text: context.tr('titles.charrito'),
                        margin: EdgeInsets.all(10),
                        padding: 10,
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextContainerWidget(
                        text: context.tr('texts.textsNosotros.charrito'),
                        margin: EdgeInsets.all(10),
                        padding: 10,
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (!isMobile) ? 40 : 20,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      TextContainerWidget(
                        text: context.tr('titles.titlePrincipal.PARTNERS'),
                        margin: EdgeInsets.all(10),
                        padding: 10,
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        alignment: Alignment.center,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 8, 66, 25),
                          fontSize: 25,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
