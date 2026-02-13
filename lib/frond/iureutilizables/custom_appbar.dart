import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../static/educacion.dart';
import '../static/comunidad.dart';
import '../auth/gestionUsuario.dart';
import '../auth/editUsuario.dart';
import '../static/ecoguias.dart';
import '../baseDatos/pages/catalogo_page.dart';
import '../static/conservrefor.dart';
import '../mapa_azuero/mapazuero.dart';
import '../static/nosotros.dart';
import '../estilos.dart';
import '../admin/consolaAdmin.dart';
import 'reglasRol.dart';
import '../../data/auth/session_provider.dart';

/// Punto de quiebre entre diseño móvil y escritorio.
const double _mobileBreakpoint = 800;

/// AppBar personalizada que se adapta a escritorio y móvil.
class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const customAppBar({Key? key, required this.context}) : super(key: key);
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

/// Logo + título.
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
            FlutterLogo(),
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

/// Menú horizontal para escritorio.
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
  List<PopupMenuEntry<String>> _trabajoItems(BuildContext ctx) => [
    _popup(ctx, 'buttons.conservref', () => _go(ctx, Conservrefor())),
    _popup(ctx, 'buttons.educacion', () => _go(ctx, Educacion())),
    _popup(ctx, 'buttons.comunidad', () => _go(ctx, Comunidad())),
  ];

  List<PopupMenuEntry<String>> _recursosItems(BuildContext ctx) => [
    _popup(ctx, 'buttons.mapa', () => _go(ctx, MappAzuero())),
    _popup(ctx, 'buttons.ecoguias', () => _go(ctx, Ecoguias())),
    _popup(ctx, 'buttons.basedatos', () => _go(ctx, const CatalogoPage())),
    if (kIsWeb)
      _popup(
        ctx,
        'buttons.biblioteca',
        () => _launchUrl(
          ctx,
          'https://www.librarything.com/catalog/ProEcoAzuero',
        ),
      ),
    _popup(ctx, 'buttons.blog', () => _go(ctx, Conservrefor())),
  ];

  PopupMenuItem<String> _popup(
    BuildContext ctx,
    String key,
    VoidCallback onTap,
  ) => PopupMenuItem<String>(
    onTap: onTap,
    child: Text(
      ctx.tr(key),
      style: const TextStyle(
        color: Estilos.verdeOscuro,
        fontSize: Estilos.textoGrande,
      ),
    ),
  );

  void _go(BuildContext ctx, Widget page) =>
      Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) => page));

  Future<void> _launchUrl(BuildContext ctx, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
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
                FlutterLogo(size: 60),
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
                _drawerTile(context, 'buttons.somos', Nosotros()),
                _drawerTile(context, 'buttons.conservref', Conservrefor()),
                _drawerTile(context, 'buttons.educacion', Educacion()),
                _drawerTile(context, 'buttons.comunidad', Comunidad()),
                _drawerTile(context, 'buttons.mapa', MappAzuero()),
                _drawerTile(context, 'buttons.ecoguias', Ecoguias()),
                _drawerTile(context, 'buttons.basedatos', CatalogoPage()),
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
                    context.tr('login'),
                    style: TextStyle(
                      color: Estilos.blanco,
                      fontWeight: FontWeight.w100,
                      fontSize: Estilos.textoPequeno,
                    ),
                  ),
                  onTap:
                      (!sesionActual.isAuthenticated)
                          ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GestionUsuario(),
                            ),
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
                const Divider(),
                tieneAlgunoDeLosRoles(context, ['administrador'])
                    ? ListTile(
                      leading: const Icon(
                        Icons.assignment_ind,
                        color: Estilos.blanco,
                      ),
                      title: Text(
                        context.tr('Admin'),
                        style: TextStyle(
                          color: Estilos.blanco,
                          fontWeight: FontWeight.w100,
                          fontSize: Estilos.textoPequeno,
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

  Widget _drawerTile(BuildContext ctx, String key, Widget page) => ListTile(
    title: Text(
      ctx.tr(key),
      style: const TextStyle(
        fontSize: Estilos.textoGrande,
        color: Estilos.blanco,
        fontWeight: FontWeight.w100,
        fontFamily: 'Oswald',
      ),
    ),
    onTap: () {
      Navigator.pop(ctx); // cierra drawer
      Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) => page));
    },
  );

  Future<void> _launchUrl(BuildContext ctx, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
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
