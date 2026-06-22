
import '../llamadas_locales/llamadas_flora.dart';
import '../llamadas_remotas/llamadas_flora.dart';
import '../llamadas_locales/sqlite_helper.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/especie_unificada.dart';
import '../llamadas_locales/tabla_sinc.dart';
import 'validar_metadatos.dart';

class FilasPorSincronizar {
  static final FilasPorSincronizar _instancia = 
        FilasPorSincronizar._singleton();
  factory FilasPorSincronizar() {
    return _instancia;
  }

 FilasPorSincronizar._singleton();

 final List<String> insertToLocal = [],
	updateToLocal = [],
	deleteToLocal = [],
	eliminarFisicoLocal = [];
  final List<String> insertToRemote = [],
	updateToRemote = [],
	deleteToRemote = [];
  final List<String> discardedLocal = [];
  
  void clear() {
    insertToLocal.clear();
    updateToLocal.clear();
    deleteToLocal.clear();

    insertToRemote.clear();
    updateToRemote.clear();
    deleteToRemote.clear();

    discardedLocal.clear();
    eliminarFisicoLocal.clear();
  }
}

class ComparadorFilas {
  final FilasPorSincronizar filasSinc;
  ComparadorFilas(this.filasSinc);

  void detectar({
    required List<dynamic> localCompleto,
    required List<dynamic> remoteCompleto,
    required List<dynamic> localCambios,
    required List<dynamic> remoteCambios,
  }){
    debugPrint('========== DETECTANDO CAMBIOS =============');
    final mapLocalCompleto = {
      for(var e in localCompleto) e['id'] as String: e,
    };
    final mapRemoteCompleto = {
     for(var e in remoteCompleto) e['id'] as String: e,
    };
    final mapLocalCambios = {for(var e in localCambios) e ['id'] as String: e};
    final mapRemoteCambios = {for(var e in remoteCambios) e['id'] as String: e};
    final todosLosIds = {...mapLocalCompleto.keys, ...mapRemoteCompleto.keys};
    
    for(final id in todosLosIds){
      final localExiste = mapLocalCompleto.containsKey(id);
      final remoteExiste = mapRemoteCompleto.containsKey(id);

      final localCambio = mapLocalCambios[id];
      final remoteCambio = mapRemoteCambios[id];

      final localFila = mapLocalCompleto[id];
      final remoteFila = mapRemoteCompleto[id];

      // Existe en ambos lados
      if(localExiste && remoteExiste){
          
        final local = localFila!;
        final remote = remoteFila!;
        debugPrint('\n el registro $id existe en ambas bd');
        // DELETE conflict
        if(local['is_delete'] == 1 || remote['is_delete'] == 1){
          debugPrint('\n conflicto delete detectado');
          _resolverConflictoDelete(id,local,remote);
          continue;
        }
        
              // ambos cambiaron
        if(localCambio != null && remoteCambio != null){
          debugPrint('\n ambos cambiaron, resolviendo conflicto');
          _resolverConflicto(id, local, remote);
          continue;
        }

              // solo local cambio enviar a remoto
        if(localCambio != null){
          debugPrint('\n solo local cambio enviar a remoto');
          filasSinc.updateToRemote.add(id);
          continue;
        }

        // solo remoto cambio enviar a local
        if(remoteCambio != null){
          debugPrint('\n solo remoto cambio enviar a local');
          filasSinc.updateToLocal.add(id);
          continue;
        }

        debugPrint('\n sin cambios');
      }
      // Existe solo en remoto
      else if(!localExiste && remoteExiste){
        debugPrint('\n el registro $id Existe solo en remoto');
        final remote = remoteFila!;
        if(remote['is_delete'] == 0){
          debugPrint('\n nuevo registro en remoto se insertara en local');
          filasSinc.insertToLocal.add(id);
        }
      }
      // Existe solo en local
      else if(localExiste && !remoteExiste){
        debugPrint('\n el registro $id Existe solo en local');
        final local = localFila!;
        if(local['is_delete'] == 0){
          debugPrint('\n nuevo registro en local se insertara en remoto');
          filasSinc.insertToRemote.add(id);
        } else {
          // eliminar por completo especie local
          debugPrint('\n eliminar por completo especie local');
          filasSinc.eliminarFisicoLocal.add(id);
        }
      }
    }
  }

  void _resolverConflictoDelete(
    String id,
    Map<String, dynamic> local,
    Map<String, dynamic> remoto,
  ){
    final vLocal = local['version'];
    final vRemoto = remoto['version'];
    debugPrint('registro $id version local: $vLocal version remota: $vRemoto');
    // Ambos ya eliminados
    if(local['is_delete'] == 1 && remoto['is_delete'] == 1){
      debugPrint('\n Ambos ya eliminados');
      filasSinc.eliminarFisicoLocal.add(id);
      return;
    }
    if(vRemoto > vLocal) {
      if(remoto['is_delete'] == 1){
      //eliminar por completo local porque esta eliminado en remoto
      debugPrint('\n eliminar por completo local porque esta eliminado en remoto');
      filasSinc.eliminarFisicoLocal.add(id);
    } else {
      filasSinc.updateToLocal.add(id);
    }
  } else if(vLocal > vRemoto) {
    debugPrint('Gana local');
    if(local['is_delete'] == 1) {
      //eliminar en remoto y luego eliminar por completo local porque ya no se va a usar
      debugPrint('\n eliminar en remoto y luego eliminar por completo local porque ya no se va a usar');
      filasSinc.deleteToRemote.add(id);
      filasSinc.eliminarFisicoLocal.add(id);
    }else{
      filasSinc.updateToRemote.add(id);
    }
  }else{
    // en versiones iguales gana remoto
    debugPrint('\n en versiones iguales gana remoto');
    if(remoto['is_delete'] == 1){
      filasSinc.eliminarFisicoLocal.add(id);
    } else {
      filasSinc.updateToLocal.add(id);
    }
  }
   }
  
  void _resolverConflicto(
    String id,
    Map<String, dynamic> local,
    Map<String, dynamic> remoto,
  ){
    if(remoto['version'] > local['version']){
      filasSinc.updateToLocal.add(id);
    } else if(local['version'] > remoto['version']){
      filasSinc.updateToRemote.add(id);
    } else{
      // en versiones iguales gana remoto
      filasSinc.updateToLocal.add(id); 
    }
  }
}



class SincronizadorLocal {
  Future<bool> ejecutar(FilasPorSincronizar filas, List<Map<String, dynamic>> remoteCompleto) async {

    final remoteMetaDataCompletaMap = {for(final e in remoteCompleto) e['id'] as String: e,};
    final db = await dbLocal.instancia;
    for(final String id in filas.deleteToLocal){
      final meta = remoteMetaDataCompletaMap[id];
      final version = meta?['version'] as int?;
      await _softDeleteLocal(id,version);
    }
    for(final String id in filas.eliminarFisicoLocal){
      await _deleteFisicoLocal(id);
    }
    if(filas.insertToLocal.isNotEmpty){
      final response = await getFlora(
        endpoint: 'getflora/porids', 
        method: 'POST',
        requiereAuth: true,
        body: {'ids': filas.insertToLocal},
      );

      final especies = response
	             .map((json) => Especie.fromJson(json))
	  	     .toList();

      for(final e in especies){
        
	      debugPrint('insertando ${e.nombre_cientifico} en bd local');
      }
      if(especies.isNotEmpty){
	      await insertFloraLocal(db, especies,remoteMetaDataCompletaMap);
      }
    }
    if(filas.updateToLocal.isNotEmpty){
      final response = await getFlora(
        endpoint: 'getflora/porids',
        method: 'POST',
        requiereAuth: true,
        body: {'ids': filas.updateToLocal},
      );

      final especies = response
	             .map((json) => Especie.fromJson(json))
	  	     .toList();
      for(final esp in especies){
        final meta = remoteMetaDataCompletaMap[esp.nombre_cientifico];
        final version = meta?['version'] as int?;
	      await updateFloraLocal(db, esp,version);
      }
    }
    return true;
  }

  Future<void> _softDeleteLocal(String id, int? version) async {
    final db = await dbLocal.instancia;
    await softDeleteLocal(db, id, version);
  }
  Future<void> _deleteFisicoLocal(String id) async {
    final db = await dbLocal.instancia;
    await deleteFloraLocal(db, id);
  }
}


class SincronizadorRemoto {
  Future<bool> ejecutar(FilasPorSincronizar filas, List<Map<String, dynamic>> localCompleto) async {
    final localMetaDataCompletaMap = {for(final e in localCompleto) e['id'] as String: e,};
    final db = await dbLocal.instancia;
    for(final id in filas.insertToRemote) {
      final meta = localMetaDataCompletaMap[id];
      final version = meta?['version'] as int?;
     final especie = await obtenerFloraLocalById(db,id);
     if(especie != null){
	    await insertAPI(especie, 'insertflora',version);
     }
    }
    for(final id in filas.updateToRemote){
      final meta = localMetaDataCompletaMap[id];
      final version = meta?['version'] as int?;
      final especie = await obtenerFloraLocalById(db, id);
      if(especie != null){
        //en local se ignoran las imagenes por lo que se recuperan, en caso de exister, al actualizar un registro localmente que existia en remoto
        final resultPorImagen = await getFlora(endpoint: 'getflora/porids',method: 'POST',requiereAuth: true,body: {'ids': [id],});
        if(resultPorImagen.isNotEmpty){
          especie['Imagen'] = resultPorImagen.first['Imagen'];
          debugPrint('\n ==== especie con imagen para subir a remoto   $especie');
        }else{
          debugPrint('\n ==== valio verga la obtencion de img   $resultPorImagen');
        }
	      await updateFloraRemoto(especie,version);
      }
    }
    for(final id in filas.deleteToRemote){
      await softDeleteFloraRemoto(id);
    }
    return true;
  }
}

class ControlSincronizacion {
  static final ControlSincronizacion _instancia = ControlSincronizacion._singleton();
  final FilasPorSincronizar filaPorSinc;
  late final ComparadorFilas detector;
  factory ControlSincronizacion(){
    return _instancia;
  }
  ControlSincronizacion._singleton() : filaPorSinc = FilasPorSincronizar() {
    detector = ComparadorFilas(filaPorSinc);
  }
  final SincronizadorLocal localSync = SincronizadorLocal();
  final SincronizadorRemoto remoteSync = SincronizadorRemoto();
  final TablaSyncLocal tablaSyncLocal = TablaSyncLocal();

  Future<void> sincronizar() async {
    await limpiarHuerfanos();
    final db = await dbLocal.instancia;
    filaPorSinc.clear();

    final ult = await db.query('ultima_sinc',limit: 1);
    final ultSinc = ult.isEmpty ? '1970-01-01T00:00:00z' : ult.first['fecha_sincronizacion'] as String;
    debugPrint('\n ultima sincronizacion: $ultSinc');
    
    final localCambios = await obtenerCambiosLocales(ultSinc);
    final remoteCambios = await obtenerCambiosRemotos(ultSinc);
    debugPrint('============== REGISTROS CAMBIADOS DESDE LA ULTIMA SINCRONIZACION ==============');
    debugPrint('\n local: $localCambios');
    debugPrint('\n remoto: $remoteCambios');

    List<Map<String, dynamic>>? localCompleto = [];
    List<Map<String, dynamic>>? remoteCompleto = [];

    localCompleto = await obtenerLocalCompleto();
    remoteCompleto = await obtenerRemotoCompleto();
    debugPrint('\n ============== REGISTROS COMPLETOS ==============');
    debugPrint(' LOCAL ');
    for(var flora in localCompleto) {
      debugPrint('nombre cientifico: ${flora['id']}');
    }
    debugPrint(' REMOTO ');
    for(var flora in remoteCompleto) {
      debugPrint('nombre cientifico: ${flora['id']}');
    }

    detector.detectar(
      localCompleto: localCompleto, 
      remoteCompleto: remoteCompleto, 
      localCambios: localCambios, 
      remoteCambios: remoteCambios
      );
      debugPrint('\n ========FILAS POR SINCRONIZAR=========');
      debugPrint('$filaPorSinc \n');
      bool ok = await remoteSync.ejecutar(filaPorSinc, localCompleto);
      if(ok){
        ok = await localSync.ejecutar(filaPorSinc,remoteCompleto);
        if(!ok){
          return;
        }
      }else{
        return;
      }
      final ahora = DateTime.now().toUtc().toIso8601String();
      final idsLoc = localCambios.map((m) => m['id'] as String).toList();
      final idsRem = remoteCambios.map((m) => m['id'] as String).toList();

      await tablaSyncLocal.guardarUltimaSincronizacion(
        db: db, 
        fecha: ahora, 
        idsLoc: idsLoc, 
        idsRem: idsRem
      );
      debugPrint('ultima sincronizacion guardada el: $ahora');
  }

  /* obtener filas actualizadas despues de la ultima sincronizacion */

  Future<List<Map<String, dynamic>>> obtenerCambiosLocales(
    String ultSinc
  ) async {
    final db = await dbLocal.instancia;
    final data = await selectLocal(db: db, tabla: 'sincronizacion', where: 'last_upd > ?', whereArgs: [ultSinc]);
    return data;
  }

  Future<List<Map<String,dynamic>>> obtenerLocalCompleto() async {
    final db = await dbLocal.instancia;
    final datos = await selectLocal(db: db, tabla: 'sincronizacion');
    return datos;
  }

  Future<List<Map<String,dynamic>>> obtenerCambiosRemotos(
    String ultSinc
  ) async {
    final filasSync = await getFlora(
      endpoint: 'getsincronizacion',
      method: 'POST',
      requiereAuth: true,
      body: {'ultSinc': ultSinc},
    );
    return filasSync.map((fila){
      return {
        'id': fila['id'],
        'version': fila['version'],
        'is_new': (fila['is_new']) ? 1 : 0,
        'is_update': (fila['is_update']) ? 1 : 0,
        'is_delete': (fila['is_delete']) ? 1 : 0,
        'last_upd': fila['last_upd'],
      };
    }).toList();   
  }

  Future<List<Map<String,dynamic>>> obtenerRemotoCompleto() async {
    final filasSync = await getFlora(
      endpoint: 'getsincronizacion',
      method: 'POST',
      requiereAuth: true,
      body: null,
    );
    return filasSync.map((fila){
      return {
        'id': fila['id'],
        'version': fila['version'],
        'is_new': (fila['is_new']) ? 1 : 0,
        'is_update': (fila['is_update']) ? 1 : 0,
        'is_delete': (fila['is_delete']) ? 1 : 0,
        'last_upd': fila['last_upd'],
      };
    }).toList(); 
  }
}