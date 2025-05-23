import 'package:ecoazuero/backend/utilidades/variableglobal.dart';

import '../../utilidades/item.dart';
import '../../lambda/remotedatabase.dart';

class crud {

  Future<String> insertarSincronizado(Item item) async {
    return await RemoteService.insertItem(item,Variableglobal().ultAct);
  }

  Future<List<Map<String,dynamic>>> leerDatos() async{
    final RemoteService v = RemoteService();
    return await v.leerDatos();
  }

}
