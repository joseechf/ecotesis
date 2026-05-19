import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/especies_provider.dart';
import '../widgets/mostrar_tarjeta/especie_card.dart';
import '../widgets/mostrar_tarjeta/especie_modal.dart';
import '../widgets/mostrar_tarjeta/filtro_dialog.dart';
import '../../../validar_red.dart';
import '../../estilos.dart';
import '../../../domain/entities/especie_unificada.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../iureutilizables/custom_appbar.dart';
import '../../iureutilizables/reglas_rol.dart';
import '../widgets/flora_insert_dialog.dart';
import '../widgets/siembra_dialog.dart';
import '../widgets/terreno_dialog.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  late Future<bool> _tieneInternet;

  @override
  void initState() {
    super.initState();
    _tieneInternet = validarRed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EspeciesProvider>().cargarFlora();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final provider = Provider.of<EspeciesProvider>(context);

    if (provider.cargandoData) {
      return Scaffold(
        appBar: CustomAppBar(context: context),
        drawer: isMobile ? const MobileMenu() : null,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Estilos.paddingMedio),
        child: SizedBox(
          width: double.infinity,
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
                  SizedBox(
                    width: 125,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final res = await mostrarFiltroDialog(
                          context,
                          provider.filtrosActivos,
                        );

                        if (res != null) {
                          provider.setFiltros(res);
                        }
                      },
                      icon: const Icon(Icons.search),
                      label: Text(context.tr('buttons.filtrar')),
                    ),
                  ),

                  FutureBuilder<bool>(
                    future: _tieneInternet,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.data == true) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        width: 140,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            provider.reinciarLocal();
                          },
                          icon: const Icon(Icons.cleaning_services),
                          label: Text(context.tr('bd local')),
                        ),
                      );
                    },
                  ),

                  FutureBuilder<bool>(
                    future: _tieneInternet,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.data != true) {
                        return const SizedBox.shrink();
                      }

                      return OutlinedButton.icon(
                        onPressed:
                            provider.sincronizando
                                ? null
                                : provider.sincronizarManual,
                        icon: const Icon(Icons.sync_alt),
                        label: Text(context.tr('buttons.sincronizar')),
                      );
                    },
                  ),

                  tieneAlgunoDeLosRoles(context, [
                        'administrador',
                        'cientifico',
                      ])
                      ? SizedBox(
                        width: 210,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final resultado = await showDialog<bool>(
                              context: context,
                              builder: (_) => const EspecieDialogInsertEdit(), 
                            );

                            if (!context.mounted) return;

                            if (resultado == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Especie guardada correctamente',
                                  ),
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
                          icon: const Icon(Icons.add),
                          label: Text(context.tr('bdInterfaz.nuevoRegistro')),
                        ),
                      )
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Estilos.grisMedio,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            context.tr('bdInterfaz.lectura'),
                            style: const TextStyle(
                              color: Estilos.grisMedio,
                              fontSize: Estilos.textoPequeno,
                            ),
                          ),
                        ],
                      ),
                  if (tieneAlgunoDeLosRoles(context, [
                    'administrador',
                    'cientifico',
                  ]))
                  FutureBuilder<bool>(
                    future: _tieneInternet,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.data != true) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                      width: 215,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final resultado = await showDialog<bool>(
                            context: context,
                            builder: (_) => const SiembraDialog(),
                          );

                          if (!context.mounted) return;

                          if (resultado == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Siembra guardada correctamente'),
                              ),
                            );
                          } else if (resultado == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al guardar la Siembra'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: Text(context.tr('bdInterfaz.nuevoSiembra')),
                      ),
                    );
                    },
                  ),
                    
                  if (tieneAlgunoDeLosRoles(context, ['administrador']))
                  FutureBuilder<bool>(
                    future: _tieneInternet,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.data != true) {
                        return const SizedBox.shrink();
                      }

                      return SizedBox(
                      width: 215,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final resultado = await showDialog<bool>(
                            context: context,
                            builder: (_) => const DialogoAgregarTerreno(),
                          );

                          if (!context.mounted) return;

                          if (resultado == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Terreno guardado correctamente'),
                              ),
                            );
                          } else if (resultado == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al guardar el Terreno'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: Text(context.tr('bdInterfaz.nuevoTerreno')),
                      ),
                    );
                    },
                  ),
                    
                ],
              ),

              const SizedBox(height: Estilos.paddingGrande),

              // Contenido
              provider.especiesFiltradas.isEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Estilos.paddingGrande,
                      ),
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
              final especieEditada = await showDialog<bool>(
                context: context,
                builder: (_) => EspecieDialogInsertEdit(especieInicial: especie),
              );
              if (!context.mounted) return;
              if (especieEditada == true) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            onEliminar: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await provider.eliminar(especie.nombreCientifico);
            },
          ),
    );
  }
}
