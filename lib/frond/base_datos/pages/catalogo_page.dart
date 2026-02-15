import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/especies_provider.dart';
import '../widgets/especie_card.dart';
import '../widgets/especie_modal.dart';
import '../widgets/filtro_dialog.dart';
import '../widgets/insertar_dialog.dart';
import '../../estilos.dart';
import '../../../domain/entities/especie.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../iureutilizables/custom_appbar.dart';
import '../../iureutilizables/reglas_rol.dart';

import '../widgets/tarjetaIncercion.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<EspeciesProvider>().cargarFlora();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EspeciesProvider>(context);
    if (provider.cargandoData) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: Padding(
        padding: const EdgeInsets.all(Estilos.paddingMedio),
        child: Column(
          children: [
            TextContainerWidget(
              text: context.tr('bdInterfaz.titulo'),
              margin: const EdgeInsets.all(16),
              padding: 12,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Estilos.verdeOscuro,
              ),
            ),

            const SizedBox(height: Estilos.paddingMedio),

            // Barra de acciones superior
            Wrap(
              spacing: Estilos.paddingPequeno, // espacio horizontal
              runSpacing:
                  Estilos.paddingPequeno, // espacio vertical al saltar de línea
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Botón de filtro
                ElevatedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(context.tr('buttons.filtrar')),
                  onPressed: () async {
                    final res = await mostrarFiltroDialog(
                      context,
                      provider.filtro,
                    );
                    if (res != null) provider.setFiltro(res);
                  },
                ),

                // Botón nuevo registro o texto de solo lectura
                tieneAlgunoDeLosRoles(context, ['administrador', 'cientifico'])
                    ? ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(context.tr('bdInterfaz.nuevoRegistro')),
                      onPressed: () async {
                        final nueva = await mostrarInsertarDialog(context);
                        if (nueva != null) provider.insertar(nueva);
                      },
                    )
                    : Text(
                      context.tr('bdInterfaz.lectura'),
                      style: TextStyle(
                        color: Estilos.grisMedio,
                        fontSize: Estilos.textoPequeno,
                      ),
                    ),

                // Botón de sincronización
                Tooltip(
                  message: context.tr('sincronizar'),
                  child: IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed:
                        provider.sincronizando
                            ? null
                            : provider.sincronizarManual,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Estilos.paddingMedio),
            Expanded(
              child:
                  provider.especiesFiltradas.isEmpty
                      ? Center(
                        child: Text(
                          context.tr('bdInterfaz.sinEspecies'),
                          style: TextStyle(
                            color: Estilos.grisMedio,
                            fontSize: Estilos.textoPequeno,
                          ),
                        ),
                      )
                      : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(Estilos.margenMedio),
                            sliver: SliverLayoutBuilder(
                              builder: (context, constraints) {
                                return SliverToBoxAdapter(
                                  child: Wrap(
                                    spacing: Estilos.margenMedio,
                                    runSpacing: Estilos.margenMedio,
                                    children: List.generate(
                                      provider.especiesFiltradas.length,
                                      (i) {
                                        final especie =
                                            provider.especiesFiltradas[i];

                                        return SizedBox(
                                          width: 300,
                                          height: 400,
                                          child: Builder(
                                            builder:
                                                (context) => EspecieCard(
                                                  especie: especie,
                                                  onTap:
                                                      () => _mostrarModal(
                                                        context,
                                                        especie,
                                                      ),
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
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

  void _mostrarModal(BuildContext context, Especie especie) {
    final provider = Provider.of<EspeciesProvider>(context, listen: false);
    showDialog(
      useRootNavigator: true,
      barrierDismissible: true,
      context: context,
      builder:
          (_) => EspecieModal(
            especie: especie,
            onEditar: () async {
              final especieEditada = await mostrarEditarDialog(
                context,
                especie,
              );
              if (!context.mounted) return;
              if (especieEditada != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Especie actualizada correctamente'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se pudo actualizar')),
                );
              }
            },
            onEliminar: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await provider.eliminar(especie.nombreCientifico);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('buttons.delete')),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
    );
  }
}
