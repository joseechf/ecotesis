import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/especie_unificada.dart';
import '../../../estilos.dart';
import '../../../../domain/value_objects.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                      Text(context.tr('bdInterfaz.insert.Ncomun')),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Estilos.paddingPequeno,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Estilos.verdeClaro,
                      borderRadius: BorderRadius.circular(Estilos.radioBorde),
                    ),
                    child:
                        (especie.estrato != null)
                            ? Text(
                              especie.estrato!,
                              style: const TextStyle(
                                fontSize: Estilos.textoPequeno,
                                color: Estilos.verdeOscuro,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagenWidget(ImagenTemp? img) {
    if (img == null) {
      return const Center(child: Icon(Icons.broken_image, size: 50));
    }
    //si la imagen aun la tengo en local muestro los bytes
    if (img.bytes != null) {
      return Image.memory(
        img.bytes!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    //si la imagen esta en el servidor uso la direccion
    if (img.urlFoto.isNotEmpty) {
      debugPrint('Intentando cargar imagen: ${img.urlFoto}');
      return CachedNetworkImage(
        imageUrl: img.urlFoto,
        width: double.infinity,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (_, _, _) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (_, _, _) => Image.asset(
              'assets/placeholder.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
      );
    }

    return const Center(child: Icon(Icons.broken_image, size: 50));
  }
}
