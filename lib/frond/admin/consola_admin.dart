import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'auth/solicitudes_rol.dart';
import '../iureutilizables/reglas_rol.dart';
import '../../backend/llamadas_remotas/llamadas_flora.dart';

class ConsolaAdmin extends StatefulWidget {
  const ConsolaAdmin({super.key});

  @override
  State<ConsolaAdmin> createState() => _ConsolaAdminState();
}

class _ConsolaAdminState extends State<ConsolaAdmin> {
  String reporte = 'sin reporte';

  Future<void> verReporte() async {
    final data = await getReporte();
    if (data['status'] == 200) {
      setState(() {
        reporte = data['reporte'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    verReporte();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final esAdmin = tieneAlgunoDeLosRoles(context, ['administrador']);

    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,
      body: SingleChildScrollView(
        child:
            esAdmin
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SolicitudesRolScreen(),
                              ),
                            );
                          },
                          child: Text(context.tr('buttons.rol')),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(reporte),
                    ],
                  ),
                )
                : Text(
                  context.tr('bdInterfaz.lectura'),
                  style: const TextStyle(
                    color: Estilos.grisMedio,
                    fontSize: Estilos.textoPequeno,
                  ),
                ),
      ),
    );
  }
}
