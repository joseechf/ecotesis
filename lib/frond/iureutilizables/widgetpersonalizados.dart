import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../conservrefor.dart';
import '../educacion.dart';
import '../comunidad.dart';

class HoverImageWidget extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final double borderRadius;

  const HoverImageWidget({
    Key? key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.borderRadius,
  }) : super(key: key);

  @override
  _HoverImageWidgetState createState() => _HoverImageWidgetState();
}

class _HoverImageWidgetState extends State<HoverImageWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15), // More transparent shadow
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Image.asset(
          widget.imagePath,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
          cacheWidth: 500,
        ),
      ),
    );
  }
}

class WidgetPersonalizados {
  WidgetPersonalizados._();

  static Widget constructorContainerText(
    String text,
    Color colorFondo,
    Color colorTexto,
    EdgeInsets margin,
    double padding,
    double tamanioText,
    String fuente,
    FontWeight tipo,
    Alignment AlineacionText, {
    int? maxLines,
    TextOverflow? overflow,
  }) {
    // Debug logs to identify centering issues
    print('DEBUG: constructorContainerText called with text: "$text"');
    print('DEBUG: Alignment parameter: ${AlineacionText.toString()}');
    print('DEBUG: Container width: Removed double.infinity to allow proper centering');
    
    //container en columna
    return Container(
      // Removed width: double.infinity to allow proper centering when used within Align widgets
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: colorFondo,
      alignment: AlineacionText,
      child: SelectableText(
        text,
        textAlign: TextAlign.center,
        maxLines: maxLines,
        style: TextStyle(
          color: colorTexto,
          fontFamily: fuente,
          fontSize: tamanioText,
          fontWeight: tipo,
          overflow: overflow ?? TextOverflow.clip,
        ),
      ),
    );
  }

  static Widget constructorContainerimg(
    String text,
    double margin,
    double padding,
    double altura,
    double radioImg,
  ) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all(padding),
      child: Image.asset(
        text,
        fit: BoxFit.cover,
        width: double.infinity,
        height:
            altura, // Fija una altura para evitar que se expanda ilimitadamente
        cacheWidth: 500,
        cacheHeight: 400,
      ),
    );
  }

  //este metodo obtiene un Map dynamic y lo ordena, la idea es recorrer el map y devolver el contenido ya estructurado en una lista de Widget
  static Widget ListaWidgetOrdenada(
    Map<String, dynamic> registro,
    double radioImg,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          registro.entries.map<Widget>((entry) {
            switch (entry.key) {
              case 'imagen':
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: HoverImageWidget(
                    imagePath: entry.value,
                    width: 340,
                    height: 340,
                    borderRadius: radioImg,
                  ),
                );
              case 'titulo':
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SelectableText(
                    '${entry.value}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 2, 30, 2), // Darker color
                      fontSize: 30,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold, // Títulos en Bold
                    ),
                  ),
                );
              case 'boton':
                return ElevatedButton(
                  onPressed: () {
                    switch (entry.value) {
                      case 'conservacion':
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Conservrefor()),
                          (route) => false,
                        );
                        break;
                      case 'educDiv':
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Educacion()),
                          (route) => false,
                        );
                        break;
                      case 'colaboracion':
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Comunidad()),
                          (route) => false,
                        );
                        break;
                      default:
                    }
                  },
                  child: Text(context.tr('buttons.aprender')),
                );

              default:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SelectableText(
                    '${entry.value}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 4, 53, 3),
                      fontSize: 18,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w300, // Texto general en Light
                    ),
                  ),
                );
            }
          }).toList(),
    );
  }

  //fila o columna
  static Widget ElijeFilaColumnaDynamico(
    List<Widget> listaWidget,
    double maxAltura,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          List<Expanded> expandedList =
              listaWidget.map((item) => Expanded(child: item)).toList();
          return Row(children: expandedList);
        } else {
          return Column(children: listaWidget);
        }
      },
    );
  }
}
