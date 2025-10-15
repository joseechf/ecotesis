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

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const customAppBar({Key? key, required this.context}) : super(key: key);

  // Definir el punto de quiebre para dispositivos móviles
  static const double _mobileBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _mobileBreakpoint;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Logo y título de la aplicación
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
                    Text(
                      'PRO ECO AZUERO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              // Espacio flexible
              Spacer(),
              
              // Botón de idioma (visible en ambas versiones)
              _LanguageToggleButton(),
              
              // Espacio flexible
              Spacer(),
              
              // Menú para escritorio o móvil
              if (!isMobile)
                _DesktopMenu()
              //else
              //  _MobileMenuOpener(),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Widget para los elementos de navegación en escritorio
class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final List<Widget>? subItems;

  const _NavItem(this.title, this.onTap, {this.subItems});

  @override
  __NavItemState createState() => __NavItemState();
}

class __NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.subItems != null && widget.subItems!.isNotEmpty
          ? PopupMenuButton<String>(
              offset: Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              onSelected: (value) {
                // Aquí se manejaría la selección del submenú
              },
              itemBuilder: (BuildContext context) {
                return widget.subItems!.map((item) {
                  if (item is PopupMenuItem<String>) {
                    return item;
                  }
                  return const PopupMenuItem<String>(
                    value: '',
                    child: Text(''),
                  );
                }).toList();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: _isHovered ? Colors.green[800] : Colors.white,
                        fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: _isHovered ? Colors.green[800] : Colors.white,
                      size: 18
                    ),
                  ],
                ),
              ),
            )
          : TextButton(
              onPressed: widget.onTap,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: _isHovered ? Colors.green[800] : Colors.white,
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
    );
  }
}

// Widget para el menú de escritorio
class _DesktopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavItem(context.tr('buttons.somos'), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Nosotros()),
            (route) => false,
          );
        }),
        _NavItem(
          context.tr('buttons.trabajo'),
          null,
          subItems: [
            PopupMenuItem<String>(
              value: 'conservref',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.conservref'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Conservrefor()),
                  (route) => false,
                );
              },
            ),
            PopupMenuItem<String>(
              value: 'educacion',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.educacion'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Educacion()),
                  (route) => false,
                );
              },
            ),
            PopupMenuItem<String>(
              value: 'comunidad',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.comunidad'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Comunidad()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        _NavItem(
          context.tr('buttons.recursos'),
          null,
          subItems: [
            PopupMenuItem<String>(
              value: 'mapa',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.mapa'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => mappAzuero()),
                  (route) => false,
                );
              },
            ),
            PopupMenuItem<String>(
              value: 'ecoguias',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.ecoguias'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Ecoguias()),
                  (route) => false,
                );
              },
            ),
            PopupMenuItem<String>(
              value: 'basedatos',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.basedatos'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => menuBD()),
                  (route) => false,
                );
              },
            ),
            if (kIsWeb)
              PopupMenuItem<String>(
                value: 'biblioteca',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    context.tr('buttons.biblioteca'),
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ),
                onTap: () async {
                  final Uri url = Uri.parse('https://www.librarything.com/catalog/ProEcoAzuero');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No se pudo abrir el enlace.')),
                    );
                  }
                },
              ),
            PopupMenuItem<String>(
              value: 'blog',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  context.tr('buttons.blog'),
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Conservrefor()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Implementa tu buscador aquí
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginInterfaz()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}

// Widget para los elementos del menú móvil
class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuItem(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        onTap();
      },
    );
  }
}

// Widget para el menú móvil (Drawer)
class MobileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: 60),
                SizedBox(height: 10),
                Text(
                  'PRO ECO AZUERO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _MenuItem(context.tr('buttons.somos'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Nosotros()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.conservref'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Conservrefor()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.educacion'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Educacion()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.comunidad'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Comunidad()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.mapa'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => mappAzuero()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.ecoguias'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Ecoguias()),
              (route) => false,
            );
          }),
          _MenuItem(context.tr('buttons.basedatos'), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => menuBD()),
              (route) => false,
            );
          }),
          if (kIsWeb)
            _MenuItem(context.tr('buttons.biblioteca'), () async {
              final Uri url = Uri.parse('https://www.librarything.com/catalog/ProEcoAzuero');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.platformDefault);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo abrir el enlace.')),
                );
              }
            }),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Text('Iniciar sesión'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginInterfaz()),
                (route) => false,
              );
            },
          ),
        ],
      ),
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

  // ver si hay internet
  Future<int?> conectar() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return 1;
    }
    return null;
  }
}
