import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';

import '../usuarios/usuarioPrueba.dart'; //este usuario es para pruebas

class ConsolaAdmin extends StatefulWidget {
  const ConsolaAdmin({super.key});

  @override
  State<ConsolaAdmin> createState() => _ConsolaAdminState();
}

class _ConsolaAdminState extends State<ConsolaAdmin> {
  usuarioLogueado usuarioPrueba = usuarioLogueado();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SingleChildScrollView(
        child:
            (!usuarioPrueba.validar('Científico'))
                ? Text(
                  context.tr('bdInterfaz.lectura'),
                  style: TextStyle(
                    color: Estilos.grisMedio,
                    fontSize: Estilos.textoPequeno,
                  ),
                )
                : Text(context.tr('admin.titulo')),
      ),
    );
  }
}
