import 'package:flutter/material.dart';
import 'iureutilizables/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'iureutilizables/widgetpersonalizados.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color fondo = const Color.fromARGB(0, 196, 230, 204);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: SafeArea(
        child: ListView(
          //child: Column(
          children: [
            WidgetPersonalizados.constructorContainerimg(
              'assets/images/mono1.jpg',
              0,
              0,
              400,
            ),

            LayoutBuilder(builder: (context, constraints){
              double ancho = constraints.maxWidth*0.090;
              return             Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 400),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/images/bosque.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 400,
                      cacheWidth: 500, //resolucion guardada en memoria
                      cacheHeight: 500,
                    ),
                  ),
                  Center(
                    child: Text(
                      'PRO ECO AZUERO',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: ancho,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
            }),


            WidgetPersonalizados.constructorContainerText(
              context.tr('texts.textsHome.texto1'),
              fondo,
              Color.fromARGB(255, 18, 90, 5),
              EdgeInsets.all(20),
              10,
              MediaQuery.of(context).size.width * 0.045,
              'Oswald',
              FontWeight.normal,
              Alignment.center,
            ),

            WidgetPersonalizados.ElijeFilaColumnaDynamico([
              WidgetPersonalizados.constructorContainerText(
                context.tr('texts.textsHome.esun'),
                const Color.fromARGB(0, 253, 255, 254),
                const Color.fromARGB(255, 20, 68, 6),
                EdgeInsets.all(20),
                10,
                30,
                'Oswald',
                FontWeight.normal,
                Alignment.centerLeft,
              ),
              WidgetPersonalizados.constructorContainerimg(
                context.tr('assets/images/doñas.jpg'),
                10,
                10,
                400,
              ),
            ],400),

            WidgetPersonalizados.ElijeFilaColumnaDynamico([
              WidgetPersonalizados.constructorContainerimg(
                context.tr('assets/images/monoArania.jpg'),
                20,
                10,
                400,
              ),
              WidgetPersonalizados.constructorContainerText(
                context.tr('texts.textsHome.monoArania'),
                const Color.fromARGB(0, 253, 255, 254),
                const Color.fromARGB(255, 20, 68, 6),
                EdgeInsets.all(10),
                10,
                30,
                'Oswald',
                FontWeight.normal,
                Alignment.centerLeft,
              )
            ],400),

            //Bloque cargando 1
            FutureBuilder<List<Map<String, String>>>(
              future: _cargarListasHacemos(context),
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
                final listaHacemos = snapshot.data!;
                return Container(
                  color: const Color.fromARGB(255, 10, 58, 6),
                  child: Column(
                    children: [
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('titles.hacemos'),
                        fondo,
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
                          return Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(listaHacemos.length, (
                              index,
                            ) {
                              return Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(5),
                                width: 350,
                                height: 600,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  children: [
                                    WidgetPersonalizados.ListaWidgetOrdenada(
                                      listaHacemos[index],
                                      0,
                                      context
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            WidgetPersonalizados.constructorContainerText(
              context.tr('texts.textsHome.NewYorkTimes'),
              const Color.fromARGB(0, 4, 66, 12),
              const Color.fromARGB(255, 5, 58, 5),
              EdgeInsets.all(20),
              10,
              MediaQuery.of(context).size.width * 0.045,
              'Oswald',
              FontWeight.normal,
              Alignment.center,
            ),
            WidgetPersonalizados.constructorContainerText(
              '- New York Times',
              const Color.fromARGB(0, 4, 66, 12),
              const Color.fromARGB(255, 5, 58, 5),
              EdgeInsets.all(20),
              10,
              20,
              'Oswald',
              FontWeight.w200,
              Alignment.center,
            ),

            //Bloque cargando 2
            FutureBuilder<List<Map<String, String>>>(
              future: _cargarlistaNoticias(context),
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
                final listaNoticias = snapshot.data!;
                return Container(
                  color: const Color.fromARGB(255, 10, 51, 4),
                  child: Column(
                    children: [
                      WidgetPersonalizados.constructorContainerText(
                        context.tr('titles.noticias'),
                        fondo,
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
                          return Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(listaNoticias.length, (
                              index,
                            ) {
                              return Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(5),
                                width: 350,
                                height: 600,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  children: [
                                    WidgetPersonalizados.ListaWidgetOrdenada(
                                      listaNoticias[index],
                                      0,
                                      context
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            WidgetPersonalizados.constructorContainerimg(
              'assets/images/manos.jpg',
              0,
              0,
              400,
            ),
          ],
          //),
        ),
      ),
    );
  }

  Future<List<Map<String, String>>> _cargarListasHacemos(
    BuildContext context,
  ) async {
    return [ 
      {
        'imagen': 'assets/images/mono1.jpg',
        'titulo': context.tr('texts.textsHome.hacemos.titulo.conservacion'),
        'resumen': context.tr('texts.textsHome.hacemos.texto.conservacion'),
        'boton': 'conservacion'
      },
      {
        'imagen': 'assets/images/mono1.jpg',
        'titulo': context.tr('texts.textsHome.hacemos.titulo.educDiv'),
        'resumen': context.tr('texts.textsHome.hacemos.texto.educDiv'),
        'boton': 'educDiv'
      },
      {
        'imagen': 'assets/images/mono1.jpg',
        'titulo': context.tr('texts.textsHome.hacemos.titulo.colaboracion'),
        'resumen': context.tr('texts.textsHome.hacemos.texto.colaboracion'),
        'boton': 'colaboracion'
      }
    ];
  }

  Future<List<Map<String, String>>> _cargarlistaNoticias(
    BuildContext context,
  ) async {
    return [
      {
        'imagen': 'assets/images/mono1.jpg',
        'fecha': context.tr('texts.textsHome.fecha'),
        'link': 'aqui va un link',
      },
      {
        'imagen': 'assets/images/mono1.jpg',
        'fecha': context.tr('texts.textsHome.fecha'),
        'link': 'aqui va un link',
      },
    ];
  }
}
