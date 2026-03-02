import 'package:flutter/material.dart';
import '../../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';

Future<Set<String>?> mostrarFiltroDialog(
  BuildContext context,
  Set<String> filtrosActuales,
) async {
  final Map<String, List<String>> categorias = {
    'Características': [
      'Da sombra',
      'Flor distintiva',
      'Fruta distintiva',
      'Pionero',
    ],
    'Ecología': [
      'Mejora suelo',
      'Crecimiento rápido',
      'Crecimiento lento',
      'Ambiente seco',
      'Ambiente húmedo',
      'Ambiente mixto',
    ],
    'Fauna asociada': [
      'Hospeda monos',
      'Hospeda aves',
      'Polinizador abeja',
      'Polinizador mariposa',
      'Polinizador mixto',
    ],
    'Origen': ['Nativa América', 'Nativa Panamá', 'Nativa Azuero'],
    'Utilidad': ['Frutal', 'Maderal', 'Ganado', 'Medicinal'],
  };

  final Set<String> seleccionados = {...filtrosActuales};

  return await showDialog<Set<String>>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Estilos.blanco,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
              ),
              child: Container(
                padding: const EdgeInsets.all(Estilos.paddingGrande),
                constraints: const BoxConstraints(maxHeight: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('buttons.filtrar'),
                      style: const TextStyle(
                        fontSize: Estilos.textoMuyGrande,
                        fontFamily: Estilos.tipografia,
                        fontWeight: FontWeight.bold,
                        color: Estilos.verdeOscuro,
                      ),
                    ),

                    const SizedBox(height: Estilos.paddingMedio),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              categorias.entries.map((entry) {
                                return _SeccionFiltro(
                                  titulo: entry.key,
                                  opciones: entry.value,
                                  seleccionados: seleccionados,
                                  onChanged: (valor, activo) {
                                    setState(() {
                                      if (activo) {
                                        seleccionados.add(valor);
                                      } else {
                                        seleccionados.remove(valor);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: Estilos.paddingMedio),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            seleccionados.clear();
                            setState(() {});
                          },
                          child: Text(
                            context.tr('bdInterfaz.limpiar'),
                            style: TextStyle(color: Estilos.grisMedio),
                          ),
                        ),

                        ElevatedButton(
                          onPressed:
                              () => Navigator.pop(context, seleccionados),
                          child: Text(context.tr('bdInterfaz.filtrar')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
  );
}

class _SeccionFiltro extends StatelessWidget {
  final String titulo;
  final List<String> opciones;
  final Set<String> seleccionados;
  final Function(String, bool) onChanged;

  const _SeccionFiltro({
    required this.titulo,
    required this.opciones,
    required this.seleccionados,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Estilos.margenMedio),
      padding: const EdgeInsets.all(Estilos.paddingMedio),
      decoration: BoxDecoration(
        color: Estilos.grisClaro,
        borderRadius: BorderRadius.circular(Estilos.radioBorde),
        boxShadow: Estilos.sombraSuave,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: Estilos.textoGrande,
              fontFamily: Estilos.tipografia,
              fontWeight: FontWeight.bold,
              color: Estilos.verdeOscuro,
            ),
          ),

          const SizedBox(height: Estilos.paddingPequeno),

          ...opciones.map((op) {
            return CheckboxListTile(
              dense: true,
              activeColor: Estilos.verdePrincipal,
              contentPadding: EdgeInsets.zero,
              title: Text(
                op,
                style: const TextStyle(
                  fontSize: Estilos.textoMedio,
                  fontFamily: Estilos.tipografia,
                ),
              ),
              value: seleccionados.contains(op),
              onChanged: (val) => onChanged(op, val ?? false),
            );
          }),
        ],
      ),
    );
  }
}
