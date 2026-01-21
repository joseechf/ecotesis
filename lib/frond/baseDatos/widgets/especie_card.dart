import 'package:flutter/material.dart';
import '../../../domain/entities/especie.dart';
import '../../estilos.dart';
import '../../../domain/value_objects.dart';

class EspecieCard extends StatelessWidget {
  final Especie especie;
  final VoidCallback onTap;

  const EspecieCard({super.key, required this.especie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imagenPrincipal =
        especie.imagenes.isNotEmpty ? especie.imagenes.first : null;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
      ),
      margin: const EdgeInsets.all(Estilos.margenMedio),
      child: InkWell(
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
                child: _imagenWidget(imagenPrincipal),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Estilos.paddingMedio),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          especie.nombreCientifico,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: Estilos.textoGrande,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Estilos.paddingPequeno,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Estilos.verdeClaro,
                          borderRadius: BorderRadius.circular(
                            Estilos.radioBorde,
                          ),
                        ),
                        child:
                            (especie.ambiente != null)
                                ? Text(
                                  especie.ambiente!,
                                  style: const TextStyle(
                                    fontSize: Estilos.textoPequeno,
                                    color: Estilos.verdeOscuro,
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nombres comunes: '),
                      Expanded(
                        // ocupa el ancho restante
                        child: ListView.builder(
                          shrinkWrap:
                              true, // solo ocupa el espacio que necesita
                          physics:
                              const ClampingScrollPhysics(), // scroll dentro del Row
                          itemCount: especie.nombresComunes.length,
                          itemBuilder:
                              (_, i) =>
                                  Text(especie.nombresComunes[i].nombreComun),
                        ),
                      ),
                    ],
                  ),
                  Text(especie.estrato ?? '—'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Decide cómo renderizar la imagen principal
  Widget _imagenWidget(ImagenTemp? img) {
    if (img == null) {
      return const Center(child: Icon(Icons.broken_image, size: 50));
    }

    if (img.bytes != null) {
      return Image.memory(
        img.bytes!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (img.urlFoto.isNotEmpty) {
      return Image.network(
        img.urlFoto,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Image.asset(
              'assets/placeholder.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
      );
    }

    return const Center(child: Icon(Icons.broken_image, size: 50));
  }
}
