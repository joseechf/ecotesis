import 'package:flutter/material.dart';
import '../models/especie.dart';

class EspeciesProvider with ChangeNotifier {
  List<Especie> _especies = [
    Especie(
      id: '1',
      titulo: 'Roble Europeo',
      imagen: '../../../../assets/images/manos.jpg',
      tipo: 'Árbol',
      nombreCientifico: 'Quercus robur',
      ubicacion: 'Europa Central',
      especie: 'Fagaceae',
    ),
    Especie(
      id: '2',
      titulo: 'Orquídea Mariposa',
      imagen: '../../../../assets/images/bosque.jpg',
      tipo: 'Flor',
      nombreCientifico: 'Phalaenopsis amabilis',
      ubicacion: 'Sudeste Asiático',
      especie: 'Orchidaceae',
    ),
    Especie(
      id: '3',
      titulo: 'Palo de Mango',
      imagen: '../../../../assets/images/yuco.jpeg',
      tipo: 'Árbol',
      nombreCientifico: 'Phalaenopsis amabilis',
      ubicacion: 'Centro America',
      especie: 'Orchidaceae',
    ),
    // ... agrega el resto
  ];

  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  List<Especie> get especiesFiltradas {
    if (_filtro == 'all') return _especies;
    return _especies.where((e) => e.tipo == _filtro).toList();
  }

  void setFiltro(String valor) {
    _filtro = valor;
    notifyListeners();
  }

  void eliminar(String id) {
    _especies.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void insertar(Especie nueva) {
    final nuevoId = (int.parse(_especies.last.id) + 1).toString();
    _especies.add(
      Especie(
        id: nuevoId,
        titulo: nueva.titulo,
        imagen: 'https://via.placeholder.com/400x300?text=${nueva.titulo}',
        tipo: nueva.tipo,
        nombreCientifico: nueva.nombreCientifico,
        ubicacion: nueva.ubicacion,
        especie: nueva.especie,
      ),
    );
    notifyListeners();
  }
}
