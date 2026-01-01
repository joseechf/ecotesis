import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';

class EspecieCard extends StatelessWidget {
  final Especie especie;
  final VoidCallback onTap;

  const EspecieCard({super.key, required this.especie, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
              child:
                  especie.imagenes.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Estilos.radioBordeGrande,
                        ),
                        child: Image.network(
                          especie.imagenes.first.urlFoto,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Center(child: Text('Sin imágenes')),
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
                              (_, i) => Text(especie.nombresComunes[i].nombres),
                        ),
                      ),
                    ],
                  ),
                  Text(especie.frutaDistintiva!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
