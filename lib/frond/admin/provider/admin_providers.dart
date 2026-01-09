import '../model/models.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../backend/llamadasRemotas/llamadasAdmin.dart';

class RegSiembraProvider with ChangeNotifier {
  final List<RSiembra> _rsiembra = [];

  bool _cargandoData = false;
  bool _mostrarSembrados = true;

  bool get cargandoData => _cargandoData;
  bool get mostrarSembrados => _mostrarSembrados;
  List<RSiembra> get rsiembra => _rsiembra;

  /// Activa o desactiva la capa de sembrados
  void toggleSembrados(bool valor) {
    _mostrarSembrados = valor;
    notifyListeners();
  }

  Future<void> cargarRegSiembra() async {
    _cargandoData = true;
    notifyListeners();

    try {
      final regSiembraDB = await getRSiembra().timeout(
        const Duration(seconds: 20),
      );

      _rsiembra.clear();
      if (regSiembraDB['ok'] == true) {
        final List<RSiembra> resultadoFormateado =
            (regSiembraDB['respuesta'] as List<dynamic>)
                .map<RSiembra>((fila) => RSiembra.jsonToEspecie(fila))
                .toList();
        _rsiembra.addAll(resultadoFormateado);
      } else {
        print('La consulta GET salió mal');
        print(regSiembraDB);
      }
    } on TimeoutException {
      print('La operación tardó demasiado');
    }
    _cargandoData = false;
    notifyListeners();
  }

  void eliminarRegistro(RSiembra registro) {
    _rsiembra.remove(registro);
    notifyListeners();
  }

  Future<void> insertarRegistro(RSiembra nuevo) async {
    _cargandoData = true;
    notifyListeners();

    try {
      final res = await insertReg(nuevo);
      if (res) _rsiembra.add(nuevo);
    } catch (e) {
      debugPrint('Error insertando registro: $e');
    }

    _cargandoData = false;
    notifyListeners();
  }
}
