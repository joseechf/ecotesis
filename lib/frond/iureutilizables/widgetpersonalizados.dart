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
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: true,
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

// Detecta hover, aplica sombra y escalado
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
        duration: Estilos.animacionMedia,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: _isHovered ? Estilos.sombraSuave : [],
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

// Layout responsivo que elige fila o columna
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

// Widget que construye una lista ordenada de elementos
class ListaWidgetOrdenada extends StatelessWidget {
  final Map<String, dynamic> datos;
  final double radioImg;
  final Function(BuildContext, String)? onNavegar;

  const ListaWidgetOrdenada({
    super.key,
    required this.datos,
    required this.radioImg,
    this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    final orden = ['imagen', 'titulo', 'boton'];

    for (final clave in orden) {
      if (!datos.containsKey(clave)) continue;
      final valor = datos[clave];

      switch (clave) {
        case 'imagen':
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Estilos.paddingPequeno,
              ),
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
              padding: const EdgeInsets.symmetric(
                vertical: Estilos.paddingPequeno,
              ),
              child: SelectableText(
                valor.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Estilos.verdeOscuro,
                  fontSize: Estilos.textoMuyGrande,
                  fontFamily: Estilos.tipografia,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          break;

        case 'boton':
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Estilos.paddingPequeno,
              ),
              child: ElevatedButton(
                onPressed:
                    onNavegar != null
                        ? () => onNavegar!(context, valor.toString())
                        : null,
                child: Text(context.tr('buttons.aprender')),
              ),
            ),
          );
          break;
      }
    }

    datos.forEach((clave, valor) {
      if (orden.contains(clave)) return;

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Estilos.paddingMedio),
          child: SelectableText(
            valor.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Estilos.verdeOscuro,
              fontSize: Estilos.textoGrande,
              fontFamily: Estilos.tipografia,
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
}
