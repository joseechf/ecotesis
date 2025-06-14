import 'package:ecoazuero/frond/mapazuero.dart';
import 'package:flutter/material.dart';
import 'package:ecoazuero/frond/conservrefor.dart';
import 'package:ecoazuero/frond/nosotros.dart';
import '../../backend/login/loginInterfaz.dart';
import '../educacion.dart';
import '../../main.dart';
import '../comunidad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../menubd.dart';
import '../ecoguias.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

/*class customAppBar extends StatelessWidget implements PreferredSizeWidget {
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
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        ),
                                        (route) => false,
                                      ),
                                ),
                                PopupMenuItem(
                                  child: Text(context.tr('buttons.educacion')),
                                  onTap:
                                      () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Educacion(),
                                        ),
                                        (route) => false,
                                      ),
                                ),
                                PopupMenuItem(
                                  child: Text(context.tr('buttons.comunidad')),
                                  onTap:
                                      () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Comunidad(),
                                        ),
                                        (route) => false,
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
                                          builder: (_) => mappAzuero(),
                                        ),
                                        (route) => false,
                                      ),
                                ),
                                PopupMenuItem(
                                  child: Text(context.tr('buttons.ecoguias')),
                                  onTap:
                                      () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Ecoguias(),
                                        ),
                                        (route) => false,
                                      ),
                                ),
                                PopupMenuItem(
                                  child: Text(context.tr('buttons.basedatos')),
                                  onTap:
                                      () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => menuBD(),
                                        ),
                                        (route) => false,
                                      ),
                                ),
                                PopupMenuItem(
                                  child: Text('Biblioteca'),
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                      'https://www.librarything.com/catalog/ProEcoAzuero',
                                    );

                                    // Espera un momento para que el popup se cierre antes de abrir el link
                                    Future.delayed(
                                      Duration(milliseconds: 10),
                                      () async {
                                        if (await canLaunchUrl(url)) {
                                          final success = await launchUrl(
                                            url,
                                            mode: LaunchMode.platformDefault,
                                          );
                                          if (!success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'No se pudo abrir el enlace.',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'La URL no es válida.',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),

                                PopupMenuItem(
                                  child: Text(context.tr('buttons.blog')),
                                  onTap:
                                      () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Conservrefor(),
                                        ),
                                        (route) => false,
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
                    MaterialPageRoute(builder: (_) => LoginInterfaz()),
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
  }*/
class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const customAppBar({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      titleSpacing: 0,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MyApp()),
                (route) => false,
              );
            },
            child: Row(
              children: [
                FlutterLogo(),
                SizedBox(width: 8),
                Text('PRO ECO AZUERO', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Spacer(),
          _LanguageToggleButton(),
          Spacer(),
          if (!isMobile) ...[
            _NavItem(context.tr('buttons.somos'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Nosotros()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.conservref'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Conservrefor()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.educacion'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Educacion()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.comunidad'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Comunidad()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.mapa'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => mappAzuero()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.ecoguias'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Ecoguias()),
                (route) => false,
              );
            }),
            _NavItem(context.tr('buttons.basedatos'), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => menuBD()),
                (route) => false,
              );
            }),
            (kIsWeb)? _NavItem(context.tr('buttons.biblioteca'), () async {
              final Uri url = Uri.parse('https://www.librarything.com/catalog/ProEcoAzuero');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.platformDefault);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo abrir el enlace.')),
                );
              }
            }): Divider(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implementa tu buscador aquí
              },
            ),
            IconButton(
                icon: Icon(Icons.account_circle_rounded),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginInterfaz()),
                    (route) => false,
                  );
                },
              ),
            
          ] else ...[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _mostrarMenuMovil(context),
            )
          ],
        ],
      ),
    );
  }

  void _mostrarMenuMovil(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView( child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuItem(context.tr('buttons.somos'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Nosotros()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.conservref'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Conservrefor()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.educacion'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Educacion()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.comunidad'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Comunidad()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.mapa'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => mappAzuero()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.ecoguias'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Ecoguias()), (r) => false);
          }),
          _MenuItem(context.tr('buttons.basedatos'), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => menuBD()), (r) => false);
          }),
          (kIsWeb)? _NavItem(context.tr('buttons.biblioteca'), () async {
              final Uri url = Uri.parse('https://www.librarything.com/catalog/ProEcoAzuero');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.platformDefault);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo abrir el enlace.')),
                );
              }
            }): Divider(),
          Divider(),
          IconButton(
                icon: Icon(Icons.account_circle_rounded),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginInterfaz()),
                    (route) => false,
                  );
                },
              ),
        ],
      ),),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuItem(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra el modal
        onTap();
      },
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final newLocale = context.locale == const Locale('en')
            ? const Locale('es')
            : const Locale('en');
        context.setLocale(newLocale);
      },
      child: Text(
        context.locale == const Locale('en') ? 'ES' : 'EN',
        style: TextStyle(color: Colors.white),
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
