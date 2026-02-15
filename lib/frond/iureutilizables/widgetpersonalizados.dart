import 'package:flutter/material.dart';
import '../estilos.dart';
import 'package:easy_localization/easy_localization.dart';

// Widget para contenedores de texto, estandariza los textos de toda la aplicación
class TextContainerWidget extends StatelessWidget {
  final String text;
  final EdgeInsets margin;
  final double padding;
  final Color? backgroundColor;
  final Alignment? alignment;
  final TextStyle style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextContainerWidget({
    super.key,
    required this.text,
    required this.margin,
    required this.padding,
    this.backgroundColor,
    this.alignment,
    required this.style,

    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: backgroundColor,
      alignment: alignment,
      child: SelectableText(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: style,
      ),
    );
  }
}

// Widget para contenedores de imágenes con estilo específico en toda la aplicación
class ImageContainerWidget extends StatelessWidget {
  final String imagePath;
  final EdgeInsets margin;
  final double padding;
  final Color? backgroundColor;
  final Alignment? alignment;

  final double height;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const ImageContainerWidget({
    super.key,
    required this.imagePath,
    required this.margin,
    required this.padding,
    this.backgroundColor,
    this.alignment,
    required this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: backgroundColor,
      alignment: alignment,
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      ),
    );
  }
}

//detecta hover, aplica sombra y escalado (animación)
class HoverImageWidget extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;

  const HoverImageWidget({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  HoverImageWidgetState createState() => HoverImageWidgetState();
}

class HoverImageWidgetState extends State<HoverImageWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            boxShadow:
                _isHovered
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
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
      ),
    );
  }
}

// Widget de diseño responsivo elige fila o columna
class ResponsiveLayout extends StatelessWidget {
  final List<Widget> children;
  final double breakpoint;

  const ResponsiveLayout({
    super.key,
    required this.children,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > breakpoint) {
      return Row(
        children: children.map((child) => Expanded(child: child)).toList(),
      );
    } else {
      return Column(children: children);
    }
  }
}

// Widget de indicador de carga personalizado
class IndicadorCarga extends StatelessWidget {
  final String? mensaje;
  final Color? color;

  const IndicadorCarga({super.key, this.mensaje, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Estilos.verdePrincipal,
            ),
          ),
          if (mensaje != null) ...[
            SizedBox(height: Estilos.paddingMedio),
            Text(
              mensaje!,
              style: TextStyle(
                fontSize: Estilos.textoMedio,
                color: Estilos.grisMedio,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Función simple que ordena un Map en widgets
Widget listaWidgetOrdenada(
  Map<String, dynamic> datos,
  double radioImg,
  BuildContext context, {
  Function(BuildContext, String)? onNavegar,
}) {
  final List<Widget> widgets = [];

  // IMPORTANTE: Define el orden fijo aquí
  final orden = ['imagen', 'titulo', 'boton'];

  // Recorre en orden definido, no el orden del Map
  for (final clave in orden) {
    if (!datos.containsKey(clave)) continue;
    final valor = datos[clave];

    switch (clave) {
      case 'imagen':
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radioImg),
              child: HoverImageWidget(
                imagePath: valor.toString(),
                width: 340,
                height: 340,
              ),
            ),
          ),
        );
        break;

      case 'titulo':
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectableText(
              valor.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 2, 30, 2),
                fontSize: 30,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        break;

      case 'boton':
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
              onPressed:
                  onNavegar != null
                      ? () => onNavegar(context, valor.toString())
                      : null,
              child: Text(context.tr('buttons.aprender')),
            ),
          ),
        );
        break;
    }
  }

  // El resto de claves como texto simple (sin orden específico)
  datos.forEach((clave, valor) {
    if (orden.contains(clave)) return; // Ya procesado arriba

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SelectableText(
          valor.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 4, 53, 3),
            fontSize: 18,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  });

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: widgets,
  );
}
