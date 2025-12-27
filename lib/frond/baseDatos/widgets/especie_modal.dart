import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';

import '../../usuarios/usuarioPrueba.dart';

import 'package:easy_localization/easy_localization.dart';

class EspecieModal extends StatelessWidget {
  final Especie especie;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const EspecieModal({
    super.key,
    required this.especie,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final usuarioPrueba =
        usuarioLogueado(); //esto debo quitarlo de aqui y usar cookies o inyectarlo
    return AlertDialog(
      shape: RoundedRectangleBorder(
        //modificar forma de tarjeta
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
      ),
      title: Text(especie.nombreCientifico),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*SizedBox(
              height: 200,
              child:
                  especie.imagenes.isNotEmpty
                      ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: especie.imagenes.length,
                        itemBuilder: (context, index) {
                          final imagen = especie.imagenes[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Estilos.radioBordeGrande,
                              ),
                              child: Image.asset(
                                imagen.urlFoto,
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      )
                      : const Center(child: Text('Sin imágenes')),
            ),*/
            /*SizedBox(
              height: 200,
              //width: double.infinity,
              child:
                  especie.imagenes.isEmpty
                      ? const Center(child: Text('Sin imágenes'))
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Estilos.radioBordeGrande,
                        ),
                        child: Image.asset(
                          especie.imagenes.first.urlFoto,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
            ),*/
            SizedBox(
              height: 200,
              width: double.infinity,
              child: const Center(child: Text('Sin imágenes')),
            ),
            const SizedBox(height: Estilos.paddingMedio),

            if (especie.saludSuelo == 1)
              _fila(Icons.label, 'Ayuda a la salud del suelo', 'Sí'),

            if (especie.frutaDistintiva != null &&
                especie.frutaDistintiva!.isNotEmpty)
              _fila(Icons.label, 'Fruta distintiva', especie.frutaDistintiva!)
            else if (especie.florDistintiva != null)
              _fila(Icons.label, 'Flor distintiva', especie.florDistintiva!),

            _fila(
              Icons.location_on,
              'Ubicación',
              especie.origenes.isNotEmpty &&
                      especie.origenes.first.origen.isNotEmpty
                  ? especie.origenes.first.origen
                  : 'No disponible',
            ),

            if (especie.estrato != null)
              _fila(Icons.grass, 'Estrato', especie.estrato!),
          ],
        ),
      ),

      actions: [
        (!usuarioPrueba.validar('Scientist') &&
                !usuarioPrueba.validar('Administrator'))
            ? Text(
              context.tr('bdInterfaz.lectura'),
              style: TextStyle(
                color: Estilos.grisMedio,
                fontSize: Estilos.textoPequeno,
              ),
            )
            : Column(
              children: [
                ElevatedButton.icon(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit),
                  label: Text(context.tr('buttons.update')),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onEliminar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.delete),
                  label: Text(context.tr('buttons.delete')),
                ),
              ],
            ),
      ],
    );
  }

  Widget _fila(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Estilos.paddingPequeno),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: Estilos.verdeOscuro),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: Estilos.textoPequeno,
                    color: Estilos.grisMedio,
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(fontSize: Estilos.textoGrande),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
