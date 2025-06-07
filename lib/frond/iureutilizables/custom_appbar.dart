import 'package:flutter/material.dart';
import 'package:ecoazuero/frond/conservrefor.dart';
import 'package:ecoazuero/frond/nosotros.dart';
import '../../backend/login/login.dart';
import '../educacion.dart';
import '../../main.dart';
import '../comunidad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../menubd.dart';
import '../ecoguias.dart';
import 'package:url_launcher/url_launcher.dart';

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
    titleSpacing: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'PRO ECO AZUERO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Row(
          children: [
            PopupMenuButton(
              position: PopupMenuPosition.over,
              icon: Icon(Icons.menu),
              itemBuilder:
              (context) => [
                PopupMenuItem(
                  child: Text(context.tr('buttons.somos')), 
                  onTap:
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Nosotros()),
                        (route) => false,
                      ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text(context.tr('buttons.trabajo')),
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
                            child: Text(context.tr('buttons.conservref')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),(route) => false,
                                ),
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.educacion')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Educacion(),
                                  ),(route) => false,
                                ),
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.comunidad')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Comunidad(),
                                  ),(route) => false,
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
                      Text(context.tr('buttons.recursos')),
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
                            child: Text(context.tr('buttons.mapa')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ),(route) => false,
                                ),
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.ecoguias')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Ecoguias(),
                                  ),(route) => false,
                                ),
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.basedatos')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => menuBD()),(route) => false,
                                ),
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.biblioteca')),
                            onTap:
                                () async {
            final url =
                'https://www.librarything.com/catalog/ProEcoAzuero';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            } else {
              throw 'No se pudo abrir el PDF';
            }
          },
                          ),
                          PopupMenuItem(
                            child: Text(context.tr('buttons.blog')),
                            onTap:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Conservrefor(),
                                  ), (route) => false,
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
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => login()),
                  (route) => false,
                );
              },
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final newLocale =
                    context.locale == const Locale('en')
                        ? const Locale('es')
                        : const Locale('en');
                context.setLocale(newLocale);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                foregroundColor: Colors.black,
                shape: StadiumBorder(),
              ),
              child: Text(tr('buttons.change_language')),
            ),
            SizedBox(width: 12),
          ],
        ),
      ],
    ),
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
