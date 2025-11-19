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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Estilos.radioBordeGrande),
              ),
              child: Image.asset(
                especie.imagen,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
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
                          especie.titulo,
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
                          borderRadius: BorderRadius.circular(Estilos.radioBorde),
                        ),
                        child: Text(
                          especie.tipo,
                          style: const TextStyle(
                            fontSize: Estilos.textoPequeno,
                            color: Estilos.verdeOscuro,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    especie.nombreCientifico,
                    style: const TextStyle(
                      fontSize: Estilos.textoMedio,
                      fontStyle: FontStyle.italic,
                      color: Estilos.grisMedio,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}