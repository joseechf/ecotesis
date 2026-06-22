import 'package:flutter/material.dart';
import '../../../../domain/entities/especie_unificada.dart';
import '../../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../iureutilizables/reglas_rol.dart';
import 'package:flutter/gestures.dart';

class EspecieModal extends StatelessWidget {
  final Especie especie;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final bool tieneInternet;
  const EspecieModal({
    super.key,
    required this.especie,
    required this.onEditar,
    required this.onEliminar,
    required this.tieneInternet,
  });

  @override  
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
      ),
      title: Text(especie.nombre_cientifico),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(tieneInternet) SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Estilos.radioBorde),
                  child: especie.imagenes.isNotEmpty
                  ? ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                      ), 
                      child: PageView.builder(
                        controller: PageController(),
                        scrollDirection: Axis.horizontal,
                          itemCount: especie.imagenes.length,
                          itemBuilder: (_, index){
                            final img = especie.imagenes[index];
                            return Image.network(
                              img.url_foto,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.contain,
                              errorBuilder: (_,_,_) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50,),
                                ),
                              ),
                            );
                          },
                      )
                    ) : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50,),
                      ),
                    ),
                ),
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              // Nombres comunes
              if(especie.nombresComunes.isNotEmpty)
                _fila(
                  Icons.label,
                  context.tr('bdInterfaz.insert.Ncomun'),
                  especie.nombresComunes.map((n) => n.nombre_comun).join(', '),
                ),
              // da sombra
              if(especie.da_sombra != null)
                _fila(
                  Icons.grass,
                  context.tr('bdInterfaz.insert.daSombra'),
                  especie.da_sombra == 1 ? 'Sí' : 'No',
                ),
              // Flor distintiva
              if(especie.flor_distintiva != null && especie.flor_distintiva != '')
                _fila(
                  Icons.local_florist,
                  context.tr('bdInterfaz.insert.florDistintiva'),
                  especie.flor_distintiva!,
                ),
              // Fruta distintiva
              if(especie.fruta_distintiva != null && especie.fruta_distintiva != '')
                _fila(
                  Icons.eco,
                  context.tr('bdInterfaz.insert.frutaDistintiva'),
                  especie.fruta_distintiva!,
                ),
              // Salud del suelo
              if(especie.salud_suelo != null)
                _fila(
                  Icons.grass,
                  context.tr('bdInterfaz.insert.saludSuelo'),
                  especie.salud_suelo == 1 ? 'Sí' : 'No',
                ),
              // Huéspedes
              if(especie.huespedes != null && especie.huespedes != '')
                _fila(
                  Icons.bug_report,
                  context.tr('bdInterfaz.insert.huespedes'),
                  especie.huespedes!,
                ), 
              // Forma de crecimiento
              if(especie.forma_crecimiento != null && especie.forma_crecimiento != '')
                _fila(
                  Icons.trending_up,
                  context.tr('bdInterfaz.insert.formaCrecimiento'),
                  especie.forma_crecimiento!,
                ), 
              // Pionero
              if(especie.forma_crecimiento != null && especie.forma_crecimiento != '')
                _fila(
                  Icons.star,
                  context.tr('bdInterfaz.insert.pionero'),
                  especie.pionero == 1 ? 'Sí' : 'No',
                ), 
              // Polinizador
              if(especie.polinizador != null && especie.polinizador != '')
                _fila(
                  Icons.emoji_nature,
                  context.tr('bdInterfaz.insert.polinizador'),
                  especie.polinizador!,
                ),
              // Ambiente
              if(especie.ambiente != null && especie.ambiente != '')
                _fila(
                  Icons.terrain,
                  context.tr('bdInterfaz.insert.ambiente'),
                  especie.ambiente!,
                ),
              // establecido_sol_sombra
              if(especie.establecido_sol_sombra != null && especie.establecido_sol_sombra != '')
                _fila(
                  Icons.terrain,
                  context.tr('bdInterfaz.insert.establecidoSolSombra'),
                  especie.establecido_sol_sombra!,
                ),
              // Nativo de América
              if(especie.nativo_america != null)
                _fila(
                  Icons.location_on,
                  context.tr('bdInterfaz.insert.nativoAmericano'),
                  especie.nativo_america == 1 ? 'Sí' : 'No',
                ),
              // Nativo de Panamá
              if(especie.nativo_panama != null)
                _fila(
                  Icons.location_on,
                  context.tr('bdInterfaz.insert.nativoPanama'),
                  especie.nativo_panama == 1 ? 'Sí' : 'No',
                ),
              // Nativo de Azuero
              if(especie.nativo_azuero != null)
                _fila(
                  Icons.location_on,
                  context.tr('bdInterfaz.insert.nativoAzuero'),
                  especie.nativo_azuero == 1 ? 'Sí' : 'No',
                ),
              // Estrato
              if(especie.estrato != null && especie.estrato != '')
                _fila(
                  Icons.layers,
                  context.tr('bdInterfaz.insert.estrato'),
                  especie.estrato!,
                ),
              // Cobertura
              if(especie.cobertura != null && especie.cobertura != 0)
                _fila(
                  Icons.layers,
                  context.tr('bdInterfaz.insert.cobertura'),
                  especie.cobertura.toString(),
                ),
              // Utilidades
              if(especie.utilidades.isNotEmpty)
                _fila(
                  Icons.build,
                  context.tr('bdInterfaz.insert.Utilidad.titulo'),
                  especie.utilidades.map((u) => u.utilidad).join(', '),
                ),
              // Orígenes
              if(especie.origenes.isNotEmpty)
                _fila(
                  Icons.build,
                  context.tr('bdInterfaz.insert.Ubicacion'),
                  especie.origenes.map((u) => u.origen).join(', '),
                ),
            ],
          ),
        ),
      ),

      actions: tieneAlgunoDeLosRoles(context, ['administrador','cientifico'])
        ? [
          ElevatedButton.icon(
            onPressed: onEditar, 
            icon: const Icon(Icons.edit),
            label: Text(context.tr('buttons.editar')),
          ),
          ElevatedButton.icon(
            onPressed: onEliminar, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete),
            label: Text(context.tr('buttons.delete')),
          ),
        ]: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.visibility,
                color: Estilos.grisMedio,
                size: 16,
              ),
              const SizedBox(width: 3,),
              Text(
                context.tr('bdInterfaz.lectura'),
                style: const TextStyle(
                  color: Estilos.grisMedio,
                  fontSize: Estilos.textoPequeno,
                ),
              )
            ],
          )
        ], 
    );
  }

  Widget _fila(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Estilos.paddingPequeno),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: Estilos.verdeOscuro,),
          const SizedBox(width: 8,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: Estilos.textoPequeno,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: Estilos.textoGrande,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}