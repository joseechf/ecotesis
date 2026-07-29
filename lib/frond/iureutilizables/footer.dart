import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../estilos.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const _donacionCant = <Map<String,dynamic>>[
    {'label': '\$25','value': 25},
    {'label': '\$50','value': 50},
    {'label': '\$75','value': 75},
    {'label': '\$100','value': 100},
    {'label': 'Otros','value': 'otros'},
  ];

  Future<void> _controlDonacion(dynamic cantidad) async {
    final url = cantidad == 'otros' ? 'https://www.paypal.com/donate'
                : 'https://www.paypal.com/donate?amount=$cantidad';
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Estilos.verdePrincipal,
      padding: const EdgeInsets.symmetric(
        vertical: Estilos.paddingMuyGrande,
        horizontal: Estilos.paddingGrande,
      ),
      child: Column(
        children: [
          //donaciones
          Text(
            context.tr('mensajes.apoyo'),
            style: TextStyle(
              color: Estilos.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Estilos.margenMedio,),
          Text(
            context.tr('texts.donacion.p1'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Estilos.blanco.withValues(alpha: 0.9),
              fontSize: Estilos.textoMedio,
            ),
          ),
          const SizedBox(height: Estilos.margenMedio,),
          Text(
            context.tr('texts.donacion.p2'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Estilos.blanco.withValues(alpha: 0.9),
              fontSize: Estilos.textoPequeno,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: Estilos.margenMedio,),
          Wrap(
            spacing: Estilos.margenMedio,
            runSpacing: Estilos.margenMedio,
            alignment: WrapAlignment.center,
            children: _donacionCant.map(
              (d) => _BotonDonacion(
                label: d['label'] as String,
                value: d['value'],
                onTap: _controlDonacion,
              ),
            ).toList(),
          ),
          const SizedBox(height: Estilos.margenMedio,),
          // redes y contactos
          LayoutBuilder(builder: (context,c){
            final narrow = MediaQuery.sizeOf(context).width < Estilos.cambioMenu;  
            return narrow ? 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _social(context),
                  const SizedBox(height: Estilos.margenGrande,),
                  _contact(context),
                ],
              ) : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _social(context)),
                  Expanded(child: _contact(context))
                ],
              );
          }),
          const SizedBox(height: Estilos.margenMedio,),
          // copyright
          const Divider(color: Estilos.verdeClaro, height: 1,),
          const SizedBox(height: Estilos.paddingGrande,),
          Text(
            '@2022 by Pro Eco Azuero.',
            style: TextStyle(
              color: Estilos.blanco.withValues(alpha: 0.9),
              fontSize: Estilos.textoPequeno,
            ),
          )
        ],
      ),
    );     
  }

  Widget _social(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SeleccionTitulo(context.tr('footer.siguenos')),
      const SizedBox(height: Estilos.margenMedio,),
      Row(
        children: [
          _iconButton(Icons.facebook, 'https://www.facebook.com/proecoazuero'),
          const SizedBox(width: Estilos.margenMedio,),
          _iconButton(
            Icons.alternate_email,
            'https://twitter.com/proecoazuero',
          ),
          const SizedBox(width: Estilos.margenMedio,),
          _iconButton(Icons.play_arrow, 'https://www.youtube.com/@proecoazuero4588'),
        ],
      )
    ],
  );

  Widget _contact(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SeleccionTitulo(context.tr('footer.contacto')),
      const SizedBox(height: Estilos.margenMedio,),
      _row(
        Icons.location_on,
        'Calle Las Malvinas, Frente a Distribuidora Libadi, Panamá',
      ),
    ],
  );

  Widget _iconButton(IconData icon, String url) => IconButton(
    icon: Icon(icon,color: Estilos.blanco,size: 28,),
    onPressed: () async {
      if(await canLaunchUrl(Uri.parse(url))){
        await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
      }
    },
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(
      minHeight: 48,
      minWidth: 48
    ),
  );
  
  Widget _row(IconData icon, String text) => Row(
    crossAxisAlignment: icon == Icons.location_on ? CrossAxisAlignment.start : CrossAxisAlignment.center,
    children: [
      Icon(icon, color: Estilos.blanco, size: 20,),
      const SizedBox(width: Estilos.margenPequeno,),
      Expanded(
        child: Text(
          text, style: TextStyle(color: Estilos.blanco, fontSize: Estilos.textoMedio),
        ),
      ),
    ],
  );
}

class _BotonDonacion extends StatelessWidget {
  final String label;
  final dynamic value;
  final Function(dynamic) onTap;
  const _BotonDonacion({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Estilos.blanco,
        foregroundColor: Estilos.verdePrincipal,
        padding: const EdgeInsets.symmetric(
          horizontal: Estilos.paddingGrande,
          vertical: Estilos.paddingMedio,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Estilos.radioBorde),
        ),
        elevation: 2,
      ),
      onPressed: () => onTap(value),
      child: Text(
        label, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
      ),
    );    
  }
}

class _SeleccionTitulo extends StatelessWidget {
  final String text;
  const _SeleccionTitulo(this.text);

  @override
  Widget build(BuildContext context) => Text (
    text,
    style: TextStyle(
      color: Estilos.blanco,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}