import 'package:flutter/material.dart';
import '../../../domain/entities/especie.dart';
import '../../estilos.dart';
import '../../../domain/value_objects.dart';

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
    final imagenPrincipal =
        especie.imagenes.isNotEmpty ? especie.imagenes.first : null;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
      ),
      title: Text(especie.nombreCientifico),

      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* ---------- imagen ---------- */
              Container(
                height: 220, // 👈 tamaño fijo = web safe
                margin: const EdgeInsets.only(bottom: Estilos.paddingMedio),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Estilos.radioBorde),
                  color: Colors.grey[200],
                  image:
                      imagenPrincipal?.urlFoto.isNotEmpty == true
                          ? DecorationImage(
                            image: NetworkImage(imagenPrincipal!.urlFoto),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    imagenPrincipal == null
                        ? const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        )
                        : null,
              ),

              const SizedBox(height: Estilos.paddingMedio),

              // Nombres comunes
              if (especie.nombresComunes.isNotEmpty)
                _fila(
                  Icons.label,
                  'Nombres comunes',
                  especie.nombresComunes.map((n) => n.nombreComun).join(', '),
                ),

              // ¿Da sombra?
              if (especie.daSombra != null)
                _fila(
                  Icons.wb_sunny,
                  'Da sombra',
                  especie.daSombra == 1 ? 'Sí' : 'No',
                ),

              // Flor distintiva
              if (especie.florDistintiva != null &&
                  especie.florDistintiva != '')
                _fila(
                  Icons.local_florist,
                  'Flor distintiva',
                  especie.florDistintiva!,
                ),

              // Fruta distintiva
              if (especie.frutaDistintiva != null &&
                  especie.frutaDistintiva != '')
                _fila(Icons.eco, 'Fruta distintiva', especie.frutaDistintiva!),

              // Salud del suelo
              if (especie.saludSuelo != null)
                _fila(
                  Icons.grass,
                  'Salud del suelo',
                  especie.saludSuelo == 1 ? 'Sí' : 'No',
                ),

              // Huéspedes
              if (especie.huespedes != null && especie.huespedes != '')
                _fila(Icons.bug_report, 'Huéspedes', especie.huespedes!),

              // Forma de crecimiento
              if (especie.formaCrecimiento != null &&
                  especie.formaCrecimiento != '')
                _fila(
                  Icons.trending_up,
                  'Forma de crecimiento',
                  especie.formaCrecimiento!,
                ),

              // ¿Es pionera?
              if (especie.pionero != null)
                _fila(
                  Icons.star,
                  'Pionera',
                  especie.pionero == 1 ? 'Sí' : 'No',
                ),

              // Polinizador
              if (especie.polinizador != null && especie.polinizador != '')
                _fila(Icons.emoji_nature, 'Polinizador', especie.polinizador!),

              // Ambiente
              if (especie.ambiente != null && especie.ambiente != '')
                _fila(Icons.terrain, 'Ambiente', especie.ambiente!),

              // Nativo de América
              if (especie.nativoAmerica != null)
                _fila(
                  Icons.location_on,
                  'Nativo de América',
                  especie.nativoAmerica == 1 ? 'Sí' : 'No',
                ),

              // Nativo de Panamá
              if (especie.nativoPanama != null)
                _fila(
                  Icons.location_on,
                  'Nativo de Panamá',
                  especie.nativoPanama == 1 ? 'Sí' : 'No',
                ),

              // Nativo de Azuero
              if (especie.nativoAzuero != null)
                _fila(
                  Icons.location_on,
                  'Nativo de Azuero',
                  especie.nativoAzuero == 1 ? 'Sí' : 'No',
                ),

              // Estrato
              if (especie.estrato != null && especie.estrato != '')
                _fila(Icons.layers, 'Estrato', especie.estrato!),

              // Utilidades
              if (especie.utilidades.isNotEmpty)
                _fila(
                  Icons.build,
                  'Utilidades',
                  especie.utilidades.map((u) => u.utilidad).join(', '),
                ),

              // Orígenes
              if (especie.origenes.isNotEmpty)
                _fila(
                  Icons.location_on,
                  'Orígenes',
                  especie.origenes.map((o) => o.origen).join(', '),
                ),
            ],
          ),
        ),
      ),

      actions: [
        ElevatedButton.icon(
          onPressed: onEditar,
          icon: const Icon(Icons.edit),
          label: const Text('Editar'),
        ),
        ElevatedButton.icon(
          onPressed: onEliminar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.delete),
          label: const Text('Eliminar'),
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
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: Estilos.textoGrande,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
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
