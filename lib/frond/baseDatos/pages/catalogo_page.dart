import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/especie.dart';
import '../providers/especies_provider.dart';
import '../widgets/especie_card.dart';
import '../widgets/especie_modal.dart';
import '../widgets/filtro_dialog.dart';
import '../widgets/insertar_dialog.dart';
import '../../estilos.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../iureutilizables/custom_appbar.dart';

import '../../usuarios/usuarioPrueba.dart';

class CatalogoPage extends StatelessWidget {
  const CatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EspeciesProvider>(context);
    double anchoPantalla = MediaQuery.of(context).size.width;
    usuarioLogueado usuarioPrueba = usuarioLogueado();
    final isMobile = anchoPantalla < 800;
    return Scaffold(
      appBar: customAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: Padding(
        padding: const EdgeInsets.all(Estilos.paddingMedio),
        child: Column(
          children: [
            WidgetPersonalizados.constructorContainerText(
              context.tr('bdInterfaz.titulo'),
              //'especies categorizadas',
              Colors.white,
              const Color.fromARGB(255, 3, 49, 13),
              EdgeInsets.all(0),
              0,
              (!isMobile) ? 30 : 20,
              'Oswald',
              FontWeight.bold,
              Alignment.center,
            ),
            const SizedBox(height: Estilos.paddingMedio),
            Row(
              children: [
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
                const SizedBox(width: Estilos.paddingPequeno),
                (!usuarioPrueba.validar('Scientist') &&
                        !usuarioPrueba.validar('Administrator'))
                    ? Text(
                      context.tr('bdInterfaz.lectura'),
                      style: TextStyle(
                        color: Estilos.grisMedio,
                        fontSize: Estilos.textoPequeno,
                      ),
                    )
                    : ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(context.tr('bdInterfaz.nuevoRegistro')),
                      onPressed: () async {
                        final nueva = await mostrarInsertarDialog(context);
                        if (nueva != null) provider.insertar(nueva);
                      },
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
                                          child: EspecieCard(
                                            especie: especie,
                                            onTap:
                                                () => _mostrarModal(
                                                  context,
                                                  especie,
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
      context: context,
      builder:
          (_) => EspecieModal(
            especie: especie,
            onEditar: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('buttons.update'))),
              );
            },
            onEliminar: () {
              Navigator.pop(context);
              provider.eliminar(especie.nombreLatino);
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
