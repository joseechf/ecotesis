import 'package:flutter/material.dart';
import 'package:ecoazuero/frond/conservrefor.dart';
import 'package:ecoazuero/frond/nosotros.dart';
import 'backend/login/login.dart';
import 'frond/educacion.dart';
import 'main.dart';
import 'frond/comunidad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'backend/menubd.dart';

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const customAppBar({Key? key, required this.context}) : super(key: key);

  RelativeRect _calculatePosition(BuildContext context, int submenuLevel) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final offset = bar.localToGlobal(Offset.zero);
    return RelativeRect.fromLTRB(
      offset.dx + bar.size.width * submenuLevel,
      offset.dy,
      offset.dx + bar.size.width * (submenuLevel + 1),
      offset.dy + bar.size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
            (route) => false,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('PRO ECO AZUERO'),
        ),
      ),
      actions: [
        PopupMenuButton(
          position: PopupMenuPosition.under, // Añade esto
          icon: Icon(Icons.menu),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  child: Text('Quiénes somos'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Nosotros()),
                      ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text('Nuestro trabajo'),
                      Spacer(),
                      Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      showMenu(
                        context: context,
                        position: _calculatePosition(context, 1),
                        items: [
                          PopupMenuItem(
                            child: Text('Conservacion y reforestacion'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Educacion'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Educacion(),
                                  ),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Hacer crecer la comunidad'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Comunidad(),
                                  ),
                                ),
                          ),
                        ],
                      );
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text('Recursos'),
                      Spacer(),
                      Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      showMenu(
                        context: context,
                        position: _calculatePosition(context, 1),
                        items: [
                          PopupMenuItem(
                            child: Text('Mapa de Azuero'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Ecoguías'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Base de datos'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => menuBD()),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Biblioteca'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),
                                ),
                          ),
                          PopupMenuItem(
                            child: Text('Blog'),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),
                                ),
                          ),
                        ],
                      );
                    });
                  },
                ),
              ],
        ),

        IconButton(
          onPressed: () {
            //if (conectar() == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => login(),
              ), // Navega a la segunda pantalla
              (route) => false,
            );
            /*} else {
              Text('necesita conexion para esta accion');
            }*/
          },
          icon: Icon(Icons.account_circle_rounded),
        ),
        ElevatedButton(
          onPressed: () {
            // Alterna entre inglés y español
            final newLocale =
                context.locale == const Locale('en')
                    ? const Locale('es')
                    : const Locale('en');
            context.setLocale(newLocale);
          },
          child: Text(tr('buttons.change_language')),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  // ver si hay internet
  Future<int?> conectar() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return 1;
    }
    return null;
  }
}
