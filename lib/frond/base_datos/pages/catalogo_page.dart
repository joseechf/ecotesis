import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/especies_provider.dart';
import '../widgets/mostrar_tarjeta/especie_card.dart';
import '../widgets/mostrar_tarjeta/especie_modal.dart';
import '../widgets/mostrar_tarjeta/filtro_dialog.dart';
//import '../widgets/insertar_dialog.dart';
import '../../estilos.dart';
import '../../../domain/entities/especie_unificada.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../iureutilizables/custom_appbar.dart';
import '../../iureutilizables/reglas_rol.dart';
import '../../iureutilizables/widget_edicion.dart';
import '../widgets/especie_dialog.dart';
//import '../widgets/tarjeta_incercion.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Estilos.paddingMedio),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
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

            // Botones
            Wrap(
              spacing: Estilos.paddingPequeno,
              runSpacing: Estilos.paddingPequeno,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                BotonPersonalizado(
                  texto: context.tr('buttons.filtrar'),
                  icono: const Icon(Icons.filter_list),
                  onPressed: () async {
                    final res = await mostrarFiltroDialog(
                      context,
                      provider.filtrosActivos,
                    );

                    if (res != null) {
                      provider.setFiltros(res);
                    }
                  },
                  ancho: 120,
                ),

                tieneAlgunoDeLosRoles(context, ['administrador', 'cientifico'])
                    ? BotonPersonalizado(
                      texto: context.tr('bdInterfaz.nuevoRegistro'),
                      icono: const Icon(Icons.add),
                      ancho: 210,
                      onPressed: () async {
                        //final resultado = await mostrarInsertarDialog(context);
                        final resultado = await showDialog<bool>(
                          context: context,
                          builder: (_) => const EspecieDialog(),
                        );
                        if (!context.mounted) return;

                        if (resultado == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Especie guardada correctamente'),
                            ),
                          );
                        } else if (resultado == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al guardar la especie'),
                            ),
                          );
                        }
                      },
                    )
                    : Text(
                      context.tr('bdInterfaz.lectura'),
                      style: const TextStyle(
                        color: Estilos.grisMedio,
                        fontSize: Estilos.textoPequeno,
                      ),
                    ),

                OutlinedButton.icon(
                  onPressed:
                      provider.sincronizando
                          ? null
                          : provider.sincronizarManual,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(context.tr('buttons.sincronizar')),
                ),
              ],
            ),

            const SizedBox(height: Estilos.paddingGrande),

            // Contenido
            provider.especiesFiltradas.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Estilos.paddingGrande),
                    child: Text(
                      context.tr('bdInterfaz.sinEspecies'),
                      style: const TextStyle(
                        color: Estilos.grisMedio,
                        fontSize: Estilos.textoPequeno,
                      ),
                    ),
                  ),
                )
                : Wrap(
                  spacing: Estilos.margenMedio,
                  runSpacing: Estilos.margenMedio,
                  children: List.generate(provider.especiesFiltradas.length, (
                    i,
                  ) {
                    final especie = provider.especiesFiltradas[i];

                    return SizedBox(
                      width: 300,
                      height: 400,
                      child: EspecieCard(
                        especie: especie,
                        onTap: () => _mostrarModal(context, especie),
                      ),
                    );
                  }),
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
              /*final especieEditada = await mostrarEditarDialog(
                context,
                especie,
              );*/
              final especieEditada = await showDialog<bool>(
                context: context,
                builder: (_) => EspecieDialog(especieInicial: especie),
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
