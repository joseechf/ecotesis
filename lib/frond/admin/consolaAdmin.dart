import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'SiembrayVentas/page/tablasadmin.dart';
import '../../frond/iureutilizables/reglasRol.dart';

import '../iureutilizables/widgetEdicion.dart';

class ConsolaAdmin extends StatefulWidget {
  const ConsolaAdmin({super.key});

  @override
  State<ConsolaAdmin> createState() => _ConsolaAdminState();
}

class _ConsolaAdminState extends State<ConsolaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SingleChildScrollView(
        child:
            tieneAlgunoDeLosRoles(context, ['admin', 'cientifico'])
                ? BotonPersonalizado(
                  texto: ("Ir a Pantalla A"),
                  onPressed:
                      () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TablasAdministrativas(),
                          ),
                        ),
                      },
                )
                : Text(
                  context.tr('bdInterfaz.lectura'),
                  style: TextStyle(
                    color: Estilos.grisMedio,
                    fontSize: Estilos.textoPequeno,
                  ),
                ),
      ),
    );
  }
}
