
/*
class Sincronizar {
  final LocalDatabase _localBD = LocalDatabase.instance;
  final _lock = Lock();

  Future<void> _syncData() async {
    final RemoteService v = RemoteService();
    await _lock.synchronized(() async {
      //bajar datos
      List<Map<String,dynamic>> ItemsRemotos = await v.leerDatos();
      for(final fila in ItemsRemotos){
        Variableglobal().setUltActSQLite(fila['ultAct']);
        final filaActual = Item(
                    id: fila['id'],
                    name: fila['nameController'],
                    tipo: fila['tipoController'],
                    ultAct: Variableglobal().getUltActSQLite(),
                  );    
        final ListaId = await _localBD.getId();
        bool coincidencia = false;
        for(var mapid in ListaId){
          if(mapid.id == filaActual.id){
            //update
            coincidencia = true;
            break;
          }
        }
        if (!coincidencia) {
          await _localBD.insertItem(filaActual);
        }
        await _localBD.marcaSincronizado(filaActual.id);
      }
      //subir datos
      final datosLocalesNoSincronizados = await _localBD.getNosincronizado();
      for (final item in datosLocalesNoSincronizados) {
        Variableglobal().setUltAct(item.ultAct);
        final success = await RemoteService.insertItem(item,Variableglobal().ultAct);
        if(success == "insercion correcta"){
          await _localBD.marcaSincronizado(item.id);
        }
      }
    });
    //aqui deberia poner un if que verifique que tabla remota no tenga ultAc > ultSinc y tabla local noSincronizado sea vacio
    Variableglobal().ultimaSinc = DateTime.now();
  }
}

class crud {
  Future<String> insertarSincronizado(Item item) async {
    final LocalDatabase _localBD = LocalDatabase.instance;
    final Sincronizar sincronizar = Sincronizar();
    final online = await _conectar();
    if(online == 1){
      final success = await RemoteService.insertItem(item,Variableglobal().ultAct);
        // Insertar en local ya sincronizado
        await _localBD.insertItem(
          Item(id: item.id, name: item.name, tipo: item.tipo,ultAct: Variableglobal().getUltActSQLite(), sincronizado: true),
        );
      // Intentar sincronizar si hay conexión
      await sincronizar._syncData();
      return success;
    } else {
      // Insertar en local como no sincronizado
      await _localBD.insertItem(Item(id: item.id, name: item.name, tipo: item.tipo,ultAct: Variableglobal().getUltActSQLite(), sincronizado: false));
    }
    return 'error en la insercion';
  }

  Future<List<Map<String,dynamic>>> leerDatos() async{
    List<Map<String,dynamic>> lista = [{'nombre': 'vacio'}];
    final online = await _conectar();
    if(online == 1){
      final RemoteService remota = RemoteService();
      return await remota.leerDatos();
    }else{
      final LocalDatabase _localBD = LocalDatabase.instance;
      lista = await _localBD.getTabla();
    }
    return lista;
  }

    //verificar si hay internet
  Future<int> _conectar() async {
    final resultados = await Connectivity().checkConnectivity(); // List<ConnectivityResult>

    if (resultados.contains(ConnectivityResult.none) || resultados.isEmpty) {
      return 0; // Sin conexión
    } else {
      return 1; // Hay alguna conexión
    }
  }
}
*/
