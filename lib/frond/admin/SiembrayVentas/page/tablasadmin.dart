import 'package:flutter/material.dart';
import '../Tablainventario/ventas.dart';
import '../Tablainventario/siembra.dart';
import '../Tablaregistro/ventas.dart';
import '../Tablaregistro/siembra.dart';
import 'package:ecoazuero/frond/estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import '../TablaTerrenos/terrenosAlquilados.dart';

class TablasAdministrativas extends StatefulWidget {
  const TablasAdministrativas({super.key});

  @override
  State<TablasAdministrativas> createState() => _TablasAdministrativasState();
}

class _TablasAdministrativasState extends State<TablasAdministrativas> {
  @override
  Widget build(BuildContext context) {
    bool pantallaAngosta = MediaQuery.of(context).size.width < 600;
    final listaTab = _buildlistaMenuTab(pantallaAngosta);
    return DefaultTabController(
      length: listaTab.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Estilos.blanco,
          title: Text(
            context.tr('admin.titulo'),
            style: TextStyle(
              color: Estilos.verdePrincipal,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: Estilos.verdePrincipal, // color del texto seleccionado
            unselectedLabelColor:
                Estilos.verdePrincipal, // color del texto NO seleccionado
            indicatorColor: Estilos.verdeOscuro, // línea de abajo
            indicatorWeight: 3, // grosor de la línea
            labelStyle: TextStyle(
              fontSize: Estilos.textoPequeno,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(fontSize: Estilos.textoPequeno),
            tabs: listaTab,
          ),
        ),
        body: Container(
          color: Estilos.blanco,
          child: const TabBarView(
            children: [
              SalesInventory(),
              RentalInventory(),
              SalesRecords(),
              RentalRecords(),
              rentedLand(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildlistaMenuTab(pantallaAngosta) {
    final lista =
        (pantallaAngosta)
            ? [
              // lista const de tabs (modo angosto)
              Tab(
                child: Tooltip(
                  message: context.tr('admin.tablas.invsiembra'),
                  child: Icon(Icons.article_outlined),
                ),
              ),
              Tab(
                child: Tooltip(
                  message: context.tr('admin.tablas.inventas'),
                  child: Icon(Icons.article),
                ),
              ),
              Tab(
                child: Tooltip(
                  message: context.tr('admin.tablas.regventas'),
                  child: Icon(Icons.add_shopping_cart),
                ),
              ),
              Tab(
                child: Tooltip(
                  message: context.tr('admin.tablas.regsiembra'),
                  child: Icon(Icons.compost),
                ),
              ),
              Tab(
                child: Tooltip(
                  message: context.tr('admin.tablas.terrenos'),
                  child: Icon(Icons.area_chart),
                ),
              ),
            ]
            : [
              // lista const de tabs (modo ancho)
              Tab(text: context.tr('admin.tablas.invsiembra')),
              Tab(text: context.tr('admin.tablas.invsiembra')),
              Tab(text: context.tr('admin.tablas.regventas')),
              Tab(text: context.tr('admin.tablas.regsiembra')),
              Tab(text: context.tr('admin.tablas.terrenos')),
            ];
    return lista;
  }
}
