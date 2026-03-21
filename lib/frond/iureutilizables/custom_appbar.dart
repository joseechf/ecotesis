import 'package:flutter/foundation.dart';
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

const double _mobileBreakpoint = 800;

// configunación boton icono navegacion
final _menuItems = [
  _Item('buttons.somos', Icons.groups, () => Nosotros()),
  _Item.group('buttons.trabajo', [
    _Item('buttons.conservref', Icons.forest, () => Conservrefor()),
    _Item('buttons.educacion', Icons.school, () => Educacion()),
    _Item('buttons.comunidad', Icons.groups, () => Comunidad()),
  ]),
  _Item.group('buttons.recursos', [
    _Item('buttons.mapa', Icons.map, () => MappAzuero()),
    _Item('buttons.ecoguias', Icons.eco, () => Ecoguias()),
    _Item('buttons.basedatos', Icons.storage, () => const CatalogoPage()),
    if (kIsWeb)
      _Item(
        'buttons.biblioteca',
        Icons.local_library,
        null,
        url: 'https://www.librarything.com/catalog/ProEcoAzuero',
      ),
  ]),
  _Item('buttons.doc', Icons.description, () => ExplicacionSincronizacion()),
];

class _Item {
  final String key;
  final IconData? icon;
  final Widget Function()? page;
  final String? url;
  final List<_Item>? children;

  bool get isGroup => children != null;
  bool get isExternal => url != null;

  const _Item(this.key, this.icon, this.page, {this.url}) : children = null;

  const _Item.group(this.key, List<_Item> items)
    : icon = null,
      page = null,
      url = null,
      children = items;
}

// AppBar principal
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const CustomAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < _mobileBreakpoint;
    return AppBar(
      backgroundColor: Estilos.verdePrincipal,
      elevation: 2,
      titleSpacing: 0,
      title: Row(
        children: [
          _Logo(onTap: () => _navigate(context, () => const MyApp())),
          const Spacer(),
          if (isMobile) ...const [_LangBtn(), SizedBox(width: 8)] else
            _DesktopMenu(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: const Padding(
      padding: EdgeInsets.all(Estilos.paddingPequeno),
      child: Text(
        'PRO ECO AZUERO',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Estilos.textoGrande,
          color: Estilos.blanco,
        ),
      ),
    ),
  );
}

// menu de pantalla grande
class _DesktopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    return Row(
      children: [
        ..._menuItems.map((i) => i.isGroup ? _Dropdown(i) : _Link(i)),
        if (_isAdmin(context))
          _IconBtn(
            Icons.assignment_ind,
            () => _navigate(context, () => const ConsolaAdmin()),
          ),
        const _LangBtn(),
        _IconBtn(
          Icons.account_circle_rounded,
          () => _navigate(
            context,
            !session.isAuthenticated
                ? () => const GestionUsuario()
                : () => EditarUsuario(
                  email: session.usuario!.email,
                  rolActual: session.usuario!.rolActual,
                  estadoRol: session.usuario!.estadoRol,
                ),
          ),
        ),
      ],
    );
  }
}

class _Link extends StatelessWidget {
  final _Item item;
  const _Link(this.item);
  @override
  Widget build(BuildContext context) =>
      _HoverText(item.key, () => _handle(context, item));
}

class _Dropdown extends StatelessWidget {
  final _Item group;
  const _Dropdown(this.group);
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    offset: const Offset(0, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Estilos.radioBorde),
    ),
    color: Estilos.blanco,
    itemBuilder:
        (_) =>
            group.children!
                .map<PopupMenuEntry<String>>(
                  (c) => PopupMenuItem<String>(
                    onTap: () => _handle(context, c),
                    child: Row(
                      children: [
                        Icon(c.icon, color: Estilos.verdeOscuro, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.tr(c.key),
                            style: const TextStyle(
                              color: Estilos.verdeOscuro,
                              fontSize: Estilos.textoGrande,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
    child: _HoverText(
      group.key,
      null,
      suffix: const Icon(Icons.arrow_drop_down, size: 18),
    ),
  );
}

class _HoverText extends StatefulWidget {
  final String labelKey;
  final VoidCallback? onTap;
  final Widget? suffix;
  const _HoverText(this.labelKey, this.onTap, {this.suffix});

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Estilos.paddingPequeno,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _hover ? Estilos.verdeOscuro : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [
            Text(
              context.tr(widget.labelKey),
              style: TextStyle(
                color: _hover ? Estilos.verdeOscuro : Estilos.blanco,
                fontSize: Estilos.textoGrande,
              ),
            ),
            if (widget.suffix != null) ...[
              const SizedBox(width: 4),
              IconTheme(
                data: IconThemeData(
                  color: _hover ? Estilos.verdeOscuro : Estilos.blanco,
                  size: 18,
                ),
                child: widget.suffix!,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

//menu movil
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
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
            child: const Center(
              child: Text(
                'PRO ECO AZUERO',
                style: TextStyle(
                  color: Estilos.blanco,
                  fontWeight: FontWeight.bold,
                  fontSize: Estilos.textoMuyGrande,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ..._expandItems(_menuItems, context),
                const Divider(),
                _Tile(Icons.account_circle_rounded, 'titles.login', () async {
                  Navigator.pop(context);
                  if (!session.isAuthenticated) {
                    final r = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (_) => const GestionUsuario()),
                    );
                    if (context.mounted && r != null) {
                      final err = r.startsWith("ERROR:");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err ? r.replaceFirst("ERROR:", "") : r),
                          backgroundColor:
                              err ? Colors.red.shade600 : Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } else {
                    _navigate(
                      context,
                      () => EditarUsuario(
                        email: session.usuario!.email,
                        rolActual: session.usuario!.rolActual,
                        estadoRol: session.usuario!.estadoRol,
                      ),
                    );
                  }
                }),
                if (_isAdmin(context))
                  _Tile(
                    Icons.assignment_ind,
                    'titles.admin',
                    () => _navigate(context, () => const ConsolaAdmin()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _expandItems(List<_Item> items, BuildContext context) {
    List<Widget> widgets = [];
    for (final item in items) {
      if (item.isGroup) {
        widgets.add(const Divider());

        for (final hijo in item.children!) {
          widgets.add(
            _Tile(hijo.icon!, hijo.key, () => _handle(context, hijo)),
          );
        }
        widgets.add(const Divider());
      } else {
        widgets.add(_Tile(item.icon!, item.key, () => _handle(context, item)));
      }
    }
    return widgets;
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;
  const _Tile(this.icon, this.labelKey, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: Estilos.blanco, size: 22),
    title: Text(
      context.tr(labelKey),
      style: const TextStyle(
        fontSize: Estilos.textoGrande,
        color: Estilos.blanco,
        fontWeight: FontWeight.w100,
        fontFamily: 'Oswald',
      ),
    ),
    onTap: onTap,
  );
}

class _LangBtn extends StatelessWidget {
  const _LangBtn();
  @override
  Widget build(BuildContext context) {
    final isEn = context.locale == const Locale('en');
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

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) =>
      IconButton(icon: Icon(icon, color: Estilos.blanco), onPressed: onTap);
}

void _navigate(BuildContext c, Widget Function() b) {
  Navigator.push(c, MaterialPageRoute(builder: (_) => b()));
}

void _handle(BuildContext c, _Item i) {
  if (i.url != null) {
    _launch(c, i.url!);
  } else {
    _navigate(c, i.page!);
  }
}

Future<void> _launch(BuildContext c, String u) async {
  final uri = Uri.parse(u);

  if (await canLaunchUrl(uri)) {
    launchUrl(uri, mode: LaunchMode.platformDefault);
  } else if (c.mounted) {
    ScaffoldMessenger.of(c).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }
}

bool _isAdmin(BuildContext c) => tieneAlgunoDeLosRoles(c, ['administrador']);
