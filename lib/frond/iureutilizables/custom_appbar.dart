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
import '../../validar_red.dart';

const double _cambioMenu = 900;

//configuracion de los elementosdel menu

List<_Item> _buildMenuItems(bool hayInternet){
  return [
    _Item('buttons.somos',Icons.groups, () => Nosotros()),
    _Item.group('buttons.trabajo',[
      _Item('buttons.conservref',Icons.forest, () => Conservrefor()),
      _Item('buttons.educacion',Icons.school, () => Educacion()),
      _Item('buttons.comunidad',Icons.groups, () => Comunidad()),
    ]),
    _Item.group('buttons.recursos', [
      if(hayInternet)
        _Item('buttons.mapa',Icons.map, ()=> MappAzuero()),
      _Item('buttons.ecoguias',Icons.eco, () => Ecoguias()),
      _Item('buttons.basedatos', Icons.storage, () => const CatalogoPage()),
      if(kIsWeb)
        _Item(
          'buttons.biblioteca',
          Icons.local_library,
          null,
          url: 'https://www.librarything.com/catalog/ProEcoAzuero',
        ),
    ]),
    _Item('buttons.doc',Icons.description, () => ExplicacionSincronizacion()),
  ];
}
class _Item{
  final String key;
  final IconData? icon;
  final Widget Function()? page;
  final String? url;
  final List<_Item>? children;

  bool get isGroup => children != null;
  bool get isExternal => url != null;

  const _Item(this.key, this.icon, this.page, {this.url}) : children = null;

  const _Item.group(this.key, List<_Item> items) :
       icon = null, page = null, url = null, children = items;
}

//AppBar principal
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const CustomAppBar({super.key, required this.context});

  @override  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < _cambioMenu;
    return AppBar(
      backgroundColor: Estilos.verdePrincipal,
      elevation: 2,
      titleSpacing: 0,
      title: Row(
        children: [
          _Logo(onTap: () => _navigate(context, ()=> const MyApp())),
          const Spacer(),
          if(isMobile) 
            ...const [_LangBtn(), SizedBox(width: 8,)] else _DesktopMenu(),
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
    child: const Padding(padding: EdgeInsets.all(Estilos.paddingPequeno),
       child: Text(
        'PRO ECO AZUERO',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Estilos.textoGrande,
          color: Estilos.blanco,
        ),
       ),
    )
  );
}

//Menu de pantalla grande (Desktop / Web) utilizando MenuBar nativo
class _DesktopMenu extends StatefulWidget {
  const _DesktopMenu();
  @override
  State<_DesktopMenu> createState() => _DesktopMenuState();
}

class _DesktopMenuState extends State<_DesktopMenu>{
  bool hayInternet = false;
  @override
  void initState(){
    super.initState();
    validarRed().then((value){
      if(!mounted) return;
        setState(() {
          hayInternet = value;
        });
    });
  }
  @override
  Widget build(BuildContext context) {
     final session = context.watch<SessionProvider>();
     final menuItems = _buildMenuItems(hayInternet);

     return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(data: Theme.of(context).copyWith(
          menuBarTheme: const MenuBarThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              elevation: WidgetStatePropertyAll(0),
            ),
          ),
        ), 
        child: MenuBar(
          children: menuItems.map((item){
            if(item.isGroup){
              return SubmenuButton(
                menuChildren: item.children!.map((hijo){
                  return MenuItemButton(
                    leadingIcon: Icon(hijo.icon, color: Estilos.verdeOscuro, size: 20,),
                    onPressed: () => _handle(context, hijo),
                    child: Text(
                      context.tr(hijo.key),
                      style: const TextStyle(color: Estilos.verdeOscuro, fontSize: Estilos.textoGrande),
                    ),
                  );
                }).toList(), 
                child: _MenuTextLabel(labelKey: item.key,hasDropdown: true),
              );
            } else {
              return MenuItemButton(
                onPressed: () => _handle(context,item),
                child: _MenuTextLabel(labelKey: item.key),
              );
            }
          }).toList(),
        )),
        if(_isAdmin(context))
           _IconBtn( 
            Icons.assignment_ind,
            () => _navigate(context, () => const ConsolaAdmin()),
           ),
           const _LangBtn(),
           _IconBtn(
            Icons.account_circle_rounded,
            () => _navigate(
              context,
              !session.isAuthenticated ?
              () => const GestionUsuario() :
            () => Scaffold(
              body: EditarUsuario(
                email: session.usuario!.email, 
                rolActual: session.usuario!.rolActual, 
                estadoRol: session.usuario!.estadoRol,
              )
            ),
            )
            
           )
      ],
     );
  }
}

class _MenuTextLabel extends StatelessWidget {
  final String labelKey;
  final bool hasDropdown;

  const _MenuTextLabel({required this.labelKey, this.hasDropdown = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: null, 
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Estilos.paddingPequeno, vertical: 4)),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states){
          if(states.contains(WidgetState.hovered)) return Estilos.verdeOscuro;
          return Estilos.blanco;
        }),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states){
          final color = states.contains(WidgetState.hovered) ? Estilos.verdeOscuro : Colors.transparent;
          return LinearBorder.bottom(
            side: BorderSide(color: color, width: 2),
          );
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr(labelKey),
            style: const TextStyle(fontSize: Estilos.textoGrande),
          ),
          if(hasDropdown) ...[
            const SizedBox(width: 4,),
            const Icon(Icons.arrow_drop_down, size: 18,),
          ],
        ],
      ),
    );
  }
}

// menu movil o pantalla chica
class MobileMenu extends StatefulWidget{
  const MobileMenu({super.key});

  @override
  State<MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<MobileMenu>{
  bool hayInternet = false;

  @override
  void initState(){
    super.initState();
    validarRed().then((value){
      if(!mounted) return;
        setState(() {
          hayInternet = value;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    final menuItems = _buildMenuItems(hayInternet);
    return Drawer(
      backgroundColor: Estilos.verdePrincipal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(Estilos.radioBordeGrande)
        ),
      ),
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Estilos.verdePrincipal),
            child: Center(
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
                ..._buildMobileItems(menuItems, context),
                const Divider(color: Estilos.blanco, thickness: 0.5,),
                _Tile(Icons.account_circle_rounded, 'titles.login',() async {
                  Navigator.pop(context);
                  if(!session.isAuthenticated){
                    final mensaje = ScaffoldMessenger.of(context);
                    final r = await Navigator.push<String>(
                      context, 
                      MaterialPageRoute(builder: (_) => const GestionUsuario()),
                    );
                    if(r != null){
                      final err = r.startsWith('ERROR:');
                      mensaje.showSnackBar(
                        SnackBar(
                          content: Text(err ? r.replaceFirst('ERROR', "") : r),
                          backgroundColor: err ? Colors.red.shade600 : 
                          Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } else {
                    if(context.mounted){
                      _navigate(
                        context,
                        () => EditarUsuario(
                          email: session.usuario!.email, 
                          rolActual: session.usuario!.rolActual, 
                          estadoRol: session.usuario!.estadoRol)
                      );
                    }
                  }
                }),
                if(_isAdmin(context))
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

  List<Widget> _buildMobileItems(List<_Item> items, BuildContext context){
    return items.map((item){
      if(item.isGroup){
        return ExpansionTile(
          iconColor: Estilos.blanco,
          collapsedIconColor: Estilos.blanco,
          textColor: Estilos.blanco,
          collapsedTextColor: Estilos.blanco,
          title: Text(
            context.tr(item.key),
            style: const TextStyle(fontSize: Estilos.textoGrande, fontFamily: 'Oswald'),
          ),
          children: item.children!
          .map((hijo) => _Tile(hijo.icon!,hijo.key, () => _handle(context, hijo))).toList(),
        );
      }
      return _Tile(item.icon!, item.key, ()=> _handle(context,item));
    }).toList();
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;
  const _Tile(this.icon,this.labelKey, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon,color: Estilos.blanco, size: 22,),
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
      onPressed: () => context.setLocale(isEn ? const Locale('es') : const Locale('en')), 
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Estilos.paddingPequeno)
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
  const _IconBtn(this.icon,this.onTap);

  @override
  Widget build(BuildContext context) => IconButton(icon: Icon(icon, color: Estilos.blanco), onPressed: onTap,);
}

void _navigate(BuildContext c, Widget Function() b) {
  Navigator.push(c, MaterialPageRoute(builder: (_) => b()));
}

void _handle(BuildContext c, _Item i) {
  if(i.url != null){
    _launch(c, i.url!);
  }else {
    _navigate(c, i.page!);
  }
}

Future<void> _launch(BuildContext c, String u) async {
  final uri = Uri.parse(u);
  if(await canLaunchUrl(uri)){
    launchUrl(uri, mode: LaunchMode.platformDefault);
  } else if (c.mounted){
    ScaffoldMessenger.of(c).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace')),
    );
  }
}

bool _isAdmin(BuildContext c) => tieneAlgunoDeLosRoles(c, ['administrador']);
