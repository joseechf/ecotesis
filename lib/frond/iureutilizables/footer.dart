import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../estilos.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const _donationAmounts = <Map<String, dynamic>>[
    {'label': '\$25', 'value': 25},
    {'label': '\$50', 'value': 50},
    {'label': '\$75', 'value': 75},
    {'label': '\$100', 'value': 100},
    {'label': 'Otros', 'value': 'custom'},
  ];

  Future<void> _handleDonation(dynamic amount) async {
    final url =
        amount == 'custom'
            ? 'https://www.paypal.com/donate'
            : 'https://www.paypal.com/donate?amount=$amount';
    if (await canLaunchUrl(Uri.parse(url))) {
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
          // Donaciones
          Text(
            'Apoya Nuestro Trabajo',
            style: TextStyle(
              color: Estilos.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Estilos.margenMedio),
          Wrap(
            spacing: Estilos.margenMedio,
            runSpacing: Estilos.margenMedio,
            alignment: WrapAlignment.center,
            children:
                _donationAmounts
                    .map(
                      (d) => _DonationButton(
                        label: d['label'] as String,
                        value: d['value'],
                        onTap: _handleDonation,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: Estilos.margenGrande),

          // Redes y contacto
          LayoutBuilder(
            builder: (_, c) {
              final narrow = c.maxWidth < 600;
              return narrow
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _social(),
                      const SizedBox(height: Estilos.margenGrande),
                      _contact(),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _social()),
                      Expanded(child: _contact()),
                    ],
                  );
            },
          ),
          const SizedBox(height: Estilos.margenGrande),

          // Copyright
          const Divider(color: Estilos.verdeClaro, height: 1),
          const SizedBox(height: Estilos.paddingGrande),
          Text(
            '©2022 by Pro Eco Azuero. Proudly created with Wix.com',
            style: TextStyle(
              color: Estilos.blanco.withOpacity(0.9),
              fontSize: Estilos.textoPequeno,
            ),
          ),
        ],
      ),
    );
  }

  Widget _social() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SectionTitle('Síguenos'),
      const SizedBox(height: Estilos.margenMedio),
      Row(
        children: [
          _iconButton(Icons.facebook, 'https://www.facebook.com/proecoazuero'),
          const SizedBox(width: Estilos.margenMedio),
          _iconButton(Icons.link, 'https://twitter.com/proecoazuero'),
          const SizedBox(width: Estilos.margenMedio),
          _iconButton(
            Icons.play_arrow,
            'https://www.youtube.com/@proecoazuero',
          ),
        ],
      ),
    ],
  );

  Widget _contact() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SectionTitle('Contacto'),
      const SizedBox(height: Estilos.margenMedio),
      _row(Icons.phone, '+507 1234-5678'),
      const SizedBox(height: Estilos.margenPequeno),
      _row(
        Icons.location_on,
        'Calle Las Malvinas, Frente a Distribuidora Libadi, Panamá',
      ),
    ],
  );

  Widget _iconButton(IconData icon, String url) => IconButton(
    icon: Icon(icon, color: Estilos.blanco, size: 28),
    onPressed: () async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    },
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
  );

  Widget _row(IconData icon, String text) => Row(
    crossAxisAlignment:
        icon == Icons.location_on
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
    children: [
      Icon(icon, color: Estilos.blanco, size: 20),
      const SizedBox(width: Estilos.margenPequeno),
      Expanded(
        child: Text(
          text,
          style: TextStyle(color: Estilos.blanco, fontSize: Estilos.textoMedio),
        ),
      ),
    ],
  );
}

class _DonationButton extends StatelessWidget {
  final String label;
  final dynamic value;
  final Function(dynamic) onTap;
  const _DonationButton({
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
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: Estilos.blanco,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}
