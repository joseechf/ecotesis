import 'package:flutter/material.dart';
import '../models/especie.dart';

import '../../../backend/llamadasRemotas/llamadasFlora.dart';

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool get cargandoData => _cargandoData;
  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  Future<void> cargarFlora() async {
    _cargandoData = true;
    notifyListeners();
    final especiesBD = await getFlora().timeout(Duration(seconds: 20));
    _especies.clear();

    if (especiesBD['ok'] == true) {
      final List<Especie> resultadoFormateado =
          (especiesBD['respuesta'] as List<dynamic>)
              .map<Especie>((fila) => Especie.jsonToEspecie(fila))
              .toList();
      print('El resultado  del get: ${resultadoFormateado}');
      //resultadoFormateado.map((fila) => _especies.addAll(fila));
      _especies.addAll(resultadoFormateado);
    } else {
      print('La consulta GET salio mal');
      print('$especiesBD');
    }

    _cargandoData = false;
    notifyListeners();
  }

  List<Especie> get especiesFiltradas {
    if (_filtro == 'all') return _especies;
    List<Especie> _especiesFiltradas = [];
    if (_filtro == 'Flor distintiva') {
      _especiesFiltradas =
          _especies.where((e) => e.florDistintiva != null).toList();
    }
    if (_filtro == 'Fruta distintiva') {
      _especiesFiltradas =
          _especies.where((e) => e.frutaDistintiva != null).toList();
    }
    if (_filtro == 'Salud del suelo') {
      _especiesFiltradas = _especies.where((e) => e.saludSuelo == 1).toList();
    }
    return _especiesFiltradas;
  }

  void setFiltro(String valor) {
    _filtro = valor;
    notifyListeners();
  }

  Future<void> eliminar(String nombreCientifico) async {
    try {
      final resp = await deleteFlora(nombreCientifico);
      if (resp) {
        print('datos eliminado en bd');
        _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);
      } else {
        print('no se elimino en bd');
      }
    } catch (e) {
      print('$e');
    }

    notifyListeners();
  }

  Future<bool> update(Especie nueva) async {
    final Map<String, dynamic> fila = nueva.toJson();
    try {
      print(fila);
      final resp = await updateFlora(fila);
      return resp;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<void> insertar(Especie nueva) async {
    try {
      final resp = await insertFlora(nueva);
      if (resp) {
        print('datos insertados en bd');
        _especies.add(nueva);
      } else {
        print('no se inserto en bd');
      }
    } catch (e) {
      print('$e');
    }
    notifyListeners();
  }

  void limpiarVectores(Especie especie) {
    especie.nombresComunes.removeWhere((e) => e.nombres.trim().isEmpty);

    especie.utilidades.removeWhere((e) => e.utilpara.trim().isEmpty);

    especie.origenes.removeWhere((e) => e.origen.trim().isEmpty);

    especie.imagenes.removeWhere((e) => e.urlFoto.trim().isEmpty);
  }
}
