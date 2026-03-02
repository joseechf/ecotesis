import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'siembray_ventas/page/tablasadmin.dart';
import 'auth/solicitudes_rol.dart';
import '../iureutilizables/reglas_rol.dart';
import '../iureutilizables/widget_edicion.dart';

class ConsolaAdmin extends StatefulWidget {
  const ConsolaAdmin({super.key});

  @override
  State<ConsolaAdmin> createState() => _ConsolaAdminState();
}

class _ConsolaAdminState extends State<ConsolaAdmin> {
  @override
  Widget build(BuildContext context) {
    final esAdmin = tieneAlgunoDeLosRoles(context, ['administrador']);

    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SingleChildScrollView(
        child:
            esAdmin
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /*BotonPersonalizado(
                        texto: "Panel de Control",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TablasAdministrativas(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),*/
                      BotonPersonalizado(
                        texto: context.tr('buttons.rol'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SolicitudesRolScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
