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
    usuarioLogueado usuarioPrueba = usuarioLogueado();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        //modificar forma de tarjeta
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
      ),
      title: Text(especie.nombre),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              //para que la imagen quede redondeada y ocupando el mismo tamaño q el dialog
              borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
              child: Image.asset(
                especie.imagen,
                height: 200,
                //width: double.infinity,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: Estilos.paddingMedio),
            _fila(Icons.label, 'establecido a', especie.establecido),
            _fila(Icons.location_on, 'Ubicación', especie.ubicacion),
            _fila(Icons.grass, 'Familia', especie.polinizador),
          ],
        ),
      ),
      actions: [
        (!usuarioPrueba.validar())
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
