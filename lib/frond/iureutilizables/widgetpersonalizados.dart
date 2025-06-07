import 'package:flutter/material.dart';

import '../conservrefor.dart';
import '../educacion.dart';
import '../comunidad.dart';

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
    Alignment AlineacionText,
  ) {
    //container en columna
    return Container(
      width: double.infinity,
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: colorFondo,
      alignment: AlineacionText,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorTexto,
          fontFamily: fuente,
          fontSize: tamanioText,
          fontWeight: tipo,
        ),
      ),
    );
  }

  static Widget constructorContainerimg(
    String text,
    double margin,
    double padding,
    double altura,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radioImg),
                    child: Image.asset(
                      entry.value,
                      width: 340,
                      height: 340,
                      fit: BoxFit.cover,
                      cacheWidth: 500,
                    ),
                  ),
                );
              case 'titulo':
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 4, 53, 3),
                      fontSize: 30,
                    ),
                  ),
                );
              case 'boton':
                return ElevatedButton(
                  onPressed: () {
                    switch (entry.value) {
                      case 'conservacion':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Conservrefor()),
                        );
                        break;
                      case 'educDiv':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Educacion()),
                        );
                        break;
                      case 'colaboracion':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Comunidad()),
                        );
                        break;
                      default:
                    }
                  },
                  child: Text('aprender mas'),
                );

              default:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 4, 53, 3),
                      fontSize: 18,
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
          return Container(
            constraints: BoxConstraints(maxHeight: maxAltura),
            child: Row(children: expandedList),
          );
        } else {
          return Column(children: listaWidget);
        }
      },
    );
  }
}
