import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Estrategia para construir widgets
abstract class WidgetBuilderStrategy {
  Widget build(BuildContext context, dynamic value);
}

// Estrategia para construir widgets de imagen con estilo personalizable
class StyledImageWidgetBuilder implements WidgetBuilderStrategy {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final BoxFit fit;

  const StyledImageWidgetBuilder({
    this.width = 340,
    this.height = 340,
    this.borderRadius = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, dynamic value) {
    final String imagePath = value as String;
    return Padding(
      padding: padding,
      child: HoverImageWidget(
        imagePath: imagePath,
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }
}

// Estrategia para construir widgets de imagen (usa StyledImageWidgetBuilder con valores por defecto)
class ImageWidgetBuilder extends StyledImageWidgetBuilder {
  ImageWidgetBuilder({required double borderRadius})
    : super(width: 340, height: 340, borderRadius: borderRadius);
}

// Estrategia para construir widgets de texto con estilo personalizable
class StyledTextWidgetBuilder implements WidgetBuilderStrategy {
  final Color textColor;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final TextAlign textAlign;

  const StyledTextWidgetBuilder({
    this.textColor = const Color.fromARGB(255, 2, 30, 2),
    this.fontSize = 30,
    this.fontFamily = 'Oswald',
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context, dynamic value) {
    final String text = value as String;
    return Padding(
      padding: padding,
      child: SelectableText(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

// Estrategia para construir widgets de título (usa StyledTextWidgetBuilder con valores por defecto)
class TitleWidgetBuilder extends StyledTextWidgetBuilder {
  TitleWidgetBuilder()
    : super(
        textColor: const Color.fromARGB(255, 2, 30, 2),
        fontSize: 30,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.bold,
      );
}

// Interfaz para la navegación
abstract class NavigationHandler {
  void navigateTo(BuildContext context, String route);
}

// Implementación por defecto del manejador de navegación
class DefaultNavigationHandler implements NavigationHandler {
  @override
  void navigateTo(BuildContext context, String route) {
    switch (route) {
      case 'conservacion':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const Placeholder(),
          ), // Placeholder hasta que se inyecte la dependencia
          (route) => false,
        );
        break;
      case 'educDiv':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const Placeholder(),
          ), // Placeholder hasta que se inyecte la dependencia
          (route) => false,
        );
        break;
      case 'colaboracion':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const Placeholder(),
          ), // Placeholder hasta que se inyecte la dependencia
          (route) => false,
        );
        break;
      default:
    }
  }
}

// Estrategia para construir widgets de botón con estilo personalizable
class StyledButtonWidgetBuilder implements WidgetBuilderStrategy {
  final NavigationHandler navigationHandler;
  final String buttonText;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  BuildContext? _context;

  StyledButtonWidgetBuilder({
    required this.navigationHandler,
    this.buttonText = 'buttons.aprender',
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
  });

  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  Widget build(BuildContext context, dynamic value) {
    final String buttonType = value as String;
    return Padding(
      padding: padding,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        onPressed: () {
          navigationHandler.navigateTo(_context ?? context, buttonType);
        },
        child: Text(
          context.tr(buttonText),
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}

// Estrategia para construir widgets de botón (usa StyledButtonWidgetBuilder con valores por defecto)
class ButtonWidgetBuilder extends StyledButtonWidgetBuilder {
  ButtonWidgetBuilder({required NavigationHandler navigationHandler})
    : super(
        navigationHandler: navigationHandler,
        buttonText: 'buttons.aprender',
      );
}

// Estrategia por defecto para construir widgets de texto (usa StyledTextWidgetBuilder con valores por defecto)
class DefaultTextWidgetBuilder extends StyledTextWidgetBuilder {
  DefaultTextWidgetBuilder()
    : super(
        textColor: const Color.fromARGB(255, 4, 53, 3),
        fontSize: 18,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w300,
        padding: const EdgeInsets.symmetric(vertical: 10),
      );
}

// Clase base para contenedores
abstract class BaseContainerWidget extends StatelessWidget {
  final EdgeInsets margin;
  final double padding;
  final Color? backgroundColor;
  final Alignment? alignment;

  const BaseContainerWidget({
    Key? key,
    required this.margin,
    required this.padding,
    this.backgroundColor,
    this.alignment,
  }) : super(key: key);

  Widget buildContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: backgroundColor,
      alignment: alignment,
      child: buildContent(),
    );
  }
}

// Widget para contenedores de texto
class TextContainerWidget extends BaseContainerWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextContainerWidget({
    Key? key,
    required this.text,
    required EdgeInsets margin,
    required double padding,
    Color? backgroundColor,
    Alignment? alignment,
    required this.textColor,
    required this.fontSize,
    required this.fontFamily,
    required this.fontWeight,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
  }) : super(
         key: key,
         margin: margin,
         padding: padding,
         backgroundColor: backgroundColor,
         alignment: alignment,
       );

  @override
  Widget buildContent() {
    return SelectableText(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: overflow ?? TextOverflow.clip,
      ),
    );
  }
}

// Widget para contenedores de imágenes
class ImageContainerWidget extends BaseContainerWidget {
  final String imagePath;
  final double height;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const ImageContainerWidget({
    Key? key,
    required this.imagePath,
    required EdgeInsets margin,
    required double padding,
    Color? backgroundColor,
    Alignment? alignment,
    required this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  }) : super(
         key: key,
         margin: margin,
         padding: padding,
         backgroundColor: backgroundColor,
         alignment: alignment,
       );

  @override
  Widget buildContent() {
    return Image.asset(
      imagePath,
      fit: fit,
      width: double.infinity,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}

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
          boxShadow:
              _isHovered
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.15,
                      ), // More transparent shadow
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

  // Método constructorContainerText refactorizado para usar TextContainerWidget
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
    return TextContainerWidget(
      text: text,
      margin: margin,
      padding: padding,
      backgroundColor: colorFondo,
      alignment: AlineacionText,
      textColor: colorTexto,
      fontSize: tamanioText,
      fontFamily: fuente,
      fontWeight: tipo,
      textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Método constructorContainerimg refactorizado para usar ImageContainerWidget
  static Widget constructorContainerimg(
    String text,
    double margin,
    double padding,
    double altura,
    double radioImg,
  ) {
    return ImageContainerWidget(
      imagePath: text,
      margin: EdgeInsets.all(margin),
      padding: padding,
      height: altura,
      cacheWidth: 500,
      cacheHeight: 400,
    );
  }

  //este metodo obtiene un Map dynamic y lo ordena, la idea es recorrer el map y devolver el contenido ya estructurado en una lista de Widget
  static Widget ListaWidgetOrdenada(
    Map<String, dynamic> registro,
    double radioImg,
    BuildContext context, {
    NavigationHandler? navigationHandler,
  }) {
    // Inicializar las estrategias
    final Map<String, WidgetBuilderStrategy> builders = {
      'imagen': ImageWidgetBuilder(borderRadius: radioImg),
      'titulo': TitleWidgetBuilder(),
      'boton': ButtonWidgetBuilder(
        navigationHandler: navigationHandler ?? DefaultNavigationHandler(),
      ),
      'default': DefaultTextWidgetBuilder(),
    };

    // Establecer el contexto para el botón
    (builders['boton'] as ButtonWidgetBuilder).setContext(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          registro.entries.map<Widget>((entry) {
            final strategy = builders[entry.key] ?? builders['default'];
            return strategy!.build(context, entry.value);
          }).toList(),
    );
  }

  //fila o columna
  static Widget ElijeFilaColumnaDynamico(
    List<Widget> listaWidget,
    double maxAltura,
  ) {
    return ResponsiveLayout.defaultLayout(
      children: listaWidget,
      breakpoint: 600,
    );
  }
}

// Widget de diseño responsivo
class ResponsiveLayout extends StatelessWidget {
  final List<Widget> children;
  final double breakpoint;
  final Widget Function(List<Widget> children) rowBuilder;
  final Widget Function(List<Widget> children) columnBuilder;

  const ResponsiveLayout({
    Key? key,
    required this.children,
    this.breakpoint = 600,
    required this.rowBuilder,
    required this.columnBuilder,
  }) : super(key: key);

  factory ResponsiveLayout.defaultLayout({
    Key? key,
    required List<Widget> children,
    double breakpoint = 600,
  }) {
    return ResponsiveLayout(
      key: key,
      children: children,
      breakpoint: breakpoint,
      rowBuilder:
          (children) => Row(
            children: children.map((child) => Expanded(child: child)).toList(),
          ),
      columnBuilder: (children) => Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > breakpoint) {
          return rowBuilder(children);
        } else {
          return columnBuilder(children);
        }
      },
    );
  }
}
