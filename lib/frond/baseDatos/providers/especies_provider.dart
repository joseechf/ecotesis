import 'package:flutter/material.dart';
import '../models/especie.dart';

class EspeciesProvider with ChangeNotifier {
  List<Especie> _especies = [
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
      establecido: 'sombra',
      ubicacion: 'Himalaya a China (Sur Yunnan) y Oeste de Malasia',
      polinizador: 'abeja',
    ),
    Especie(
      nombreLatino: 'Syzygium malaccense',
      nombre: 'Marañón curasao',
      imagen: 'assets/images/yuco.jpeg',
      establecido: 'sombra',
      ubicacion: 'Indochina a Vanuatu',
      polinizador: 'abeja',
    ),
    // ... agrega el resto
  ];

  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  List<Especie> get especiesFiltradas {
    if (_filtro == 'all') return _especies;
    return _especies.where((e) => e.establecido == _filtro).toList();
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
