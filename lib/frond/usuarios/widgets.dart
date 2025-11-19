import 'package:flutter/material.dart';
import '../estilos.dart';

// Widget de botón personalizado con estilo consistente
class BotonPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color? color;
  final Color? colorTexto;
  final double? ancho;
  final double? alto;
  final bool cargando;
  final Widget? icono;

  const BotonPersonalizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.color,
    this.colorTexto,
    this.ancho,
    this.alto,
    this.cargando = false,
    this.icono,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho ?? double.infinity,
      height: alto ?? 48,
      child: ElevatedButton(
        onPressed: cargando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Estilos.verdePrincipal,
          foregroundColor: colorTexto ?? Estilos.blanco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
          ),
        ),
        child: cargando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icono != null) ...[
                    icono!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    texto,
                    style: TextStyle(
                      fontSize: Estilos.textoGrande,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Widget de campo de texto personalizado
class CampoTextoPersonalizado extends StatelessWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final IconData? icono;
  final bool esContrasena;
  final bool ocultarTexto;
  final VoidCallback? onPressedIcono;
  final TextInputType? tipoTeclado;
  final String? Function(String?)? validador;
  final int? maxLineas;

  const CampoTextoPersonalizado({
    Key? key,
    required this.controlador,
    required this.etiqueta,
    this.icono,
    this.esContrasena = false,
    this.ocultarTexto = true,
    this.onPressedIcono,
    this.tipoTeclado,
    this.validador,
    this.maxLineas = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena ? ocultarTexto : false,
      keyboardType: tipoTeclado,
      maxLines: maxLineas,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono != null ? Icon(icono) : null,
        suffixIcon: esContrasena
            ? IconButton(
                icon: Icon(ocultarTexto ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: onPressedIcono,
              )
            : null,
      ),
      validator: validador,
    );
  }
}

// Widget de tarjeta con animación
class TarjetaAnimada extends StatefulWidget {
  final Widget hijo;
  final double? ancho;
  final double? alto;
  final EdgeInsetsGeometry? margen;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const TarjetaAnimada({
    Key? key,
    required this.hijo,
    this.ancho,
    this.alto,
    this.margen,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  State<TarjetaAnimada> createState() => _TarjetaAnimadaState();
}

class _TarjetaAnimadaState extends State<TarjetaAnimada>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      duration: Estilos.animacionMedia,
      vsync: this,
    );
    _animacion = CurvedAnimation(
      parent: _controlador,
      curve: Curves.easeInOut,
    );
    _controlador.forward();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margen,
      width: widget.ancho,
      height: widget.alto,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animacion,
          builder: (context, hijo) {
            return Transform.scale(
              scale: _animacion.value,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
                ),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(Estilos.paddingMedio),
                  child: widget.hijo,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget de indicador de carga personalizado
class IndicadorCarga extends StatelessWidget {
  final String? mensaje;
  final Color? color;

  const IndicadorCarga({
    Key? key,
    this.mensaje,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color ?? Estilos.verdePrincipal),
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

// Widget de texto con animación de aparición
class TextoAnimado extends StatefulWidget {
  final String texto;
  final TextStyle? estilo;
  final Duration? duracion;
  final Curve? curva;

  const TextoAnimado({
    Key? key,
    required this.texto,
    this.estilo,
    this.duracion,
    this.curva,
  }) : super(key: key);

  @override
  State<TextoAnimado> createState() => _TextoAnimadoState();
}

class _TextoAnimadoState extends State<TextoAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      duration: widget.duracion ?? Estilos.animacionMedia,
      vsync: this,
    );
    _animacion = CurvedAnimation(
      parent: _controlador,
      curve: widget.curva ?? Curves.easeInOut,
    );
    _controlador.forward();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animacion,
      builder: (context, hijo) {
        return FadeTransition(
          opacity: _animacion,
          child: Text(
            widget.texto,
            style: widget.estilo,
          ),
        );
      },
    );
  }
}