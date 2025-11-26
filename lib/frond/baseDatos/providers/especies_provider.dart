import 'package:flutter/material.dart';
import '../models/especie.dart';

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [
    Especie(
      nombreLatino: 'Swietenia macrophylla',
      nombre: 'Caoba',
      imagen: 'assets/images/manos.jpg',
      establecido: 'Establecido al sol',
      ubicacion: 'Mesoamerica',
      polinizador: 'abeja',
    ),
    Especie(
      nombreLatino: 'Syzygium jambos',
      nombre: 'Pomarosa',
      imagen: 'assets/images/bosque.jpg',
      establecido: 'Establecido a la sombra',
      ubicacion: 'Himalaya a China (Sur Yunnan) y Oeste de Malasia',
      polinizador: 'abeja',
    ),
    Especie(
      nombreLatino: 'Syzygium malaccense',
      nombre: 'Marañón curasao',
      imagen: 'assets/images/yuco.jpeg',
      establecido: 'Establecido a la sombra',
      ubicacion: 'Indochina a Vanuatu',
      polinizador: 'abeja',
    ),
  ];

  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  List<Especie> get especiesFiltradas {
    if (_filtro == 'all') return _especies;
    List<Especie> _especiesFiltradas = [];
    if (_filtro == 'Establecido al sol') {
      _especiesFiltradas =
          _especies.where((e) => e.establecido == _filtro).toList();
    }
    if (_filtro == 'Mesoamerica') {
      _especiesFiltradas =
          _especies.where((e) => e.ubicacion == _filtro).toList();
    }
    if (_filtro == 'abeja') {
      _especiesFiltradas =
          _especies.where((e) => e.polinizador == _filtro).toList();
    }
    return _especiesFiltradas;
  }

  void setFiltro(String valor) {
    _filtro = valor;
    notifyListeners();
  }

  void eliminar(String nombreLatino) {
    _especies.removeWhere((e) => e.nombreLatino == nombreLatino);
    notifyListeners();
  }

  void insertar(Especie nueva) {
    final nuevoId = (int.parse(_especies.last.nombreLatino) + 1).toString();
    _especies.add(
      Especie(
        nombreLatino: nuevoId,
        nombre: nueva.nombre,
        imagen: 'https://via.placeholder.com/400x300?text=${nueva.nombre}',
        establecido: nueva.establecido,
        ubicacion: nueva.ubicacion,
        polinizador: nueva.polinizador,
      ),
    );
    notifyListeners();
  }
}
