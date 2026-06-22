import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoazuero/domain/value_objects.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/especie_unificada.dart';
import '../../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';


class EspecieCard extends StatelessWidget {
  final Especie especie;
  final VoidCallback onTap;
  final bool tieneInternet;

  const EspecieCard({super.key, required this.especie, required this.onTap, required this.tieneInternet});



  @override
  Widget build(BuildContext context) {
    final imagenPrincipal = especie.imagenes.isNotEmpty ? especie.imagenes.first : null;
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
            if(tieneInternet) SizedBox(
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
                  Text(
                    especie.nombre_cientifico,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: Estilos.textoGrande,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Estilos.margenPequeno,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Estilos.verdeClaro,
                            borderRadius: BorderRadius.circular(Estilos.radioBorde),
                          ),
                          child: Text(context.tr('bdInterfaz.insert.Ncomun'), 
                          style: TextStyle(fontSize: Estilos.textoMedio,)),
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: especie.nombresComunes.take(1).map((n) => Text(n.nombre_comun)).toList(),
                        ),),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Estilos.paddingPequeno,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Estilos.verdeClaro,
                        borderRadius: BorderRadius.circular(Estilos.radioBorde),
                      ),
                      child: (especie.estrato != null)
                          ? Text(
                            especie.estrato!,style: const TextStyle(
                              fontSize: Estilos.textoPequeno,
                              color: Estilos.verdeOscuro,
                            ),
                          ) : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 5,),
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Estilos.paddingPequeno,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Estilos.verdeClaro,
                            borderRadius: BorderRadius.circular(Estilos.radioBorde),
                          ),
                          child: Text(context.tr('bdInterfaz.insert.Utilidad.titulo'), 
                          style: TextStyle(fontSize: Estilos.textoMedio,)),
                        ),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: especie.utilidades.take(1).map((n) => Text(n.utilidad)).toList(),
                        ),),
                      ],
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
    if(img == null){
      return const Center(
        child: Icon(Icons.broken_image,size: 50,),
      );
    }

    // imagen local temporal
    if(img.bytes != null){
      return Image.memory(
        img.bytes!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // imagen desde servidor
    if(img.url_foto.isNotEmpty){
      debugPrint('Intentando cargar imagen: ${img.url_foto}');

      return CachedNetworkImage(
        imageUrl: img.url_foto,
        width: double.infinity,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (_,_,_) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (_,_,_) => const Center(
          child: Icon(Icons.broken_image, size: 50),
        ),
      );
    }

    // cuando no hay imagen
    return Image.asset(
      'assets/images/logo.png',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}