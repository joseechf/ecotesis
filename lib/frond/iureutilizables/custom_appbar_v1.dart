/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../static/educacion.dart';
import '../static/comunidad.dart';
import '../auth/gestion_usuario.dart';
import '../auth/edit_usuario.dart';
import '../static/ecoguias.dart';
import '../base_datos/pages/catalogo_page.dart';
import '../static/conservrefor.dart';
import '../mapa_azuero/mapazuero.dart';
import '../static/nosotros.dart';
import '../estilos.dart';
import '../admin/consola_admin.dart';
import 'reglas_rol.dart';
import '../../data/auth/session_provider.dart';
import '../static/doc_sincronizacion.dart';

// Punto de quiebre entre diseño móvil y escritorio.
const double _mobileBreakpoint = 800;

// AppBar personalizada que se adapta a escritorio y móvil.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const CustomAppBar({super.key, required this.context});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < _mobileBreakpoint;
    return AppBar(
      backgroundColor: Estilos.verdePrincipal,
      elevation: 2,
      titleSpacing: 0,
      title: Row(
        children: [
          _LogoTitle(
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyApp()),
                ),
          ),
          const Spacer(),
          isMobile
              ? Row(
                children: const [
                  _LanguageToggleButton(),
                  SizedBox(width: Estilos.margenPequeno),
                ],
              )
              : const _DesktopMenu(),
        ],
      ),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  const _LogoTitle({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Estilos.radioBorde),
      child: const Padding(
        padding: EdgeInsets.all(Estilos.paddingPequeno),
        child: Row(
          children: [
            SizedBox(width: Estilos.paddingPequeno),
            Text(
              'PRO ECO AZUERO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Estilos.textoGrande,
                color: Estilos.blanco,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Menú horizontal para escritorio.
class _DesktopMenu extends StatelessWidget {
  const _DesktopMenu();

  @override
  Widget build(BuildContext context) {
    final sesionActual = context.watch<SessionProvider>();
    return Row(
      children: [
        _NavItem(context.tr('buttons.somos'), () => _go(context, Nosotros())),
        _NavItem(
          context.tr('buttons.trabajo'),
          null,
          subItems: _trabajoItems(context),
        ),
        _NavItem(
          context.tr('buttons.recursos'),
          null,
          subItems: _recursosItems(context),
        ),
        tieneAlgunoDeLosRoles(context, ['administrador'])
            ? IconButton(
              icon: const Icon(Icons.assignment_ind, color: Estilos.blanco),
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ConsolaAdmin()),
                  ),
            )
            : const SizedBox.shrink(),
        _NavItem(
          context.tr('buttons.doc'),
          () => _go(context, ExplicacionSincronizacion()),
        ),
        const _LanguageToggleButton(),
        IconButton(
          icon: const Icon(Icons.account_circle_rounded, color: Estilos.blanco),
          onPressed:
              (!sesionActual.isAuthenticated)
                  ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GestionUsuario()),
                  )
                  : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditarUsuario(
                            email: sesionActual.usuario!.email,
                            rolActual: sesionActual.usuario!.rolActual,
                            estadoRol: sesionActual.usuario!.estadoRol,
                          ),
                    ),
                  ),
        ),
      ],
    );
  }

  /* ---------- submenús ---------- */
  List<PopupMenuEntry<String>> _trabajoItems(BuildContext context) => [
    _popup(
      context,
      'buttons.conservref',
      Icons.forest,
      () => _go(context, Conservrefor()),
    ),
    _popup(
      context,
      'buttons.educacion',
      Icons.school,
      () => _go(context, Educacion()),
    ),
    _popup(
      context,
      'buttons.comunidad',
      Icons.groups,
      () => _go(context, Comunidad()),
    ),
  ];

  List<PopupMenuEntry<String>> _recursosItems(BuildContext context) => [
    _popup(
      context,
      'buttons.mapa',
      Icons.map,
      () => _go(context, MappAzuero()),
    ),
    _popup(
      context,
      'buttons.ecoguias',
      Icons.eco,
      () => _go(context, Ecoguias()),
    ),
    _popup(
      context,
      'buttons.basedatos',
      Icons.storage,
      () => _go(context, const CatalogoPage()),
    ),
    if (kIsWeb)
      _popup(
        context,
        'buttons.biblioteca',
        Icons.local_library,
        () => _launchUrl(
          context,
          'https://www.librarything.com/catalog/ProEcoAzuero',
        ),
      ),
  ];

  PopupMenuItem<String> _popup(
    BuildContext context,
    String key,
    IconData icono,
    VoidCallback onTap,
  ) => PopupMenuItem<String>(
    onTap: onTap,
    child: SizedBox(
      width: 260,
      child: Row(
        children: [
          Icon(icono, color: Estilos.verdeOscuro, size: 20),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              context.tr(key),
              style: const TextStyle(
                color: Estilos.verdeOscuro,
                fontSize: Estilos.textoGrande,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _go(BuildContext contexto, Widget pagina) {
    Navigator.pushReplacement(
      contexto,
      MaterialPageRoute(builder: (contextoRuta) => pagina),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    }
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem(this.title, this.onTap, {this.subItems});
  final String title;
  final VoidCallback? onTap;
  final List<PopupMenuEntry<String>>? subItems;
  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool hasMenu = widget.subItems?.isNotEmpty == true;
    final border = BorderSide(
      color: _hovered ? Estilos.verdeOscuro : Colors.transparent,
      width: 2,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child:
          hasMenu
              ? PopupMenuButton<String>(
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Estilos.radioBorde),
                ),
                color: Estilos.blanco,
                itemBuilder: (_) => widget.subItems!,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Estilos.paddingPequeno,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(border: Border(bottom: border)),
                  child: Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color:
                              _hovered ? Estilos.verdeOscuro : Estilos.blanco,
                          fontSize: Estilos.textoGrande,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _hovered ? Estilos.verdeOscuro : Estilos.blanco,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              )
              : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Estilos.paddingPequeno,
                  vertical: 4,
                ),
                decoration: BoxDecoration(border: Border(bottom: border)),
                child: TextButton(
                  onPressed: widget.onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: _hovered ? Estilos.verdeOscuro : Estilos.blanco,
                      fontSize: Estilos.textoGrande,
                    ),
                  ),
                ),
              ),
    );
  }
}

// Menú lateral para pantallas pequeñas
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final sesionActual = context.watch<SessionProvider>();
    return Drawer(
      backgroundColor: Estilos.verdePrincipal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(Estilos.radioBordeGrande),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Estilos.verdePrincipal,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(Estilos.radioBordeGrande),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Estilos.margenPequeno),
                Text(
                  'PRO ECO AZUERO',
                  style: TextStyle(
                    color: Estilos.blanco,
                    fontWeight: FontWeight.bold,
                    fontSize: Estilos.textoMuyGrande,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerTile(context, 'buttons.somos', Icons.groups, Nosotros()),
                _drawerTile(
                  context,
                  'buttons.conservref',
                  Icons.forest,
                  Conservrefor(),
                ),
                _drawerTile(
                  context,
                  'buttons.educacion',
                  Icons.school,
                  Educacion(),
                ),
                _drawerTile(
                  context,
                  'buttons.comunidad',
                  Icons.groups,
                  Comunidad(),
                ),
                const Divider(),
                _drawerTile(context, 'buttons.mapa', Icons.map, MappAzuero()),
                _drawerTile(context, 'buttons.ecoguias', Icons.eco, Ecoguias()),
                _drawerTile(
                  context,
                  'buttons.basedatos',
                  Icons.storage,
                  CatalogoPage(),
                ),
                _drawerTile(
                  context,
                  'buttons.doc',
                  Icons.description,
                  ExplicacionSincronizacion(),
                ),
                if (kIsWeb)
                  ListTile(
                    title: Text(
                      context.tr('buttons.biblioteca'),
                      style: TextStyle(
                        color: Estilos.blanco,
                        fontWeight: FontWeight.w100,
                        fontSize: Estilos.textoPequeno,
                      ),
                    ),
                    onTap:
                        () => _launchUrl(
                          context,
                          'https://www.librarything.com/catalog/ProEcoAzuero',
                        ),
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.account_circle_rounded,
                    color: Estilos.blanco,
                  ),
                  title: Text(
                    context.tr('titles.login'),
                    style: TextStyle(
                      color: Estilos.blanco,
                      fontWeight: FontWeight.w100,
                      fontSize: Estilos.textoMedio,
                    ),
                  ),
                  onTap:
                      (!sesionActual.isAuthenticated)
                          ? () async {
                            final resultado = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GestionUsuario(),
                              ),
                            );

                            if (!context.mounted || resultado == null) return;

                            final esError = resultado.startsWith("ERROR:");
                            final mensaje =
                                esError
                                    ? resultado.replaceFirst("ERROR:", "")
                                    : resultado;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(mensaje),
                                backgroundColor:
                                    esError
                                        ? Colors.red.shade600
                                        : Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                          : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditarUsuario(
                                    email: sesionActual.usuario!.email,
                                    rolActual: sesionActual.usuario!.rolActual,
                                    estadoRol: sesionActual.usuario!.estadoRol,
                                  ),
                            ),
                          ),
                ),
                const Divider(),
                tieneAlgunoDeLosRoles(context, ['administrador'])
                    ? ListTile(
                      leading: const Icon(
                        Icons.assignment_ind,
                        color: Estilos.blanco,
                      ),
                      title: Text(
                        context.tr('titles.admin'),
                        style: TextStyle(
                          color: Estilos.blanco,
                          fontWeight: FontWeight.w100,
                          fontSize: Estilos.textoMedio,
                        ),
                      ),
                      onTap:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConsolaAdmin(),
                            ),
                          ),
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context,
    String key,
    IconData icono,
    Widget page,
  ) => ListTile(
    leading: Icon(icono, color: Estilos.blanco, size: 22),

    title: Text(
      context.tr(key),
      style: const TextStyle(
        fontSize: Estilos.textoGrande,
        color: Estilos.blanco,
        fontWeight: FontWeight.w100,
        fontFamily: 'Oswald',
      ),
    ),

    onTap: () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    },
  );

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    }
  }
}

// boton para cambiar idioma
class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton();

  @override
  Widget build(BuildContext context) {
    final bool isEn = context.locale == const Locale('en');
    return TextButton(
      onPressed:
          () =>
              context.setLocale(isEn ? const Locale('es') : const Locale('en')),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Estilos.paddingPequeno),
      ),
      child: Text(
        isEn ? 'ES' : 'EN',
        style: const TextStyle(
          color: Estilos.blanco,
          fontSize: Estilos.textoGrande,
        ),
      ),
    );
  }
}
*/
