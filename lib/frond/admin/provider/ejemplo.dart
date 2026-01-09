import '../model/models.dart';

final List<Sembrable> paraSiembra = [
  Sembrable(
    idSiembra: '1',
    nombreLatino: 'Especie A',
    cantDisponible: 10,
    forma: 'semilla',
  ),
  Sembrable(
    idSiembra: '2',
    nombreLatino: 'Especie B',
    cantDisponible: 2,
    forma: 'planta',
  ),
];

final List<Vendibles> paraVenta = [
  Vendibles(
    idVendible: '1',
    nombreLatino: 'Especie X',
    cantDisponible: 3,
    forma: 'semilla',
  ),
  Vendibles(
    idVendible: '2',
    nombreLatino: 'Especie Y',
    cantDisponible: 2,
    forma: 'planta',
  ),
];

final List<RVentas> vendidos = [
  RVentas(
    idRegistro: '1',
    idVendible: '1',
    nombreLatino: 'Especie X',
    idUsuario: '1',
    nombreUsuario: 'Cesar',
    fecha: '10-9-2025',
    cantidad: 2,
  ),
];

final List<terrenosAlquilados> terrenos = [
  terrenosAlquilados(
    idAlquiler: '1',
    idUsuario: '1',
    fechaInicio: '12-12-2025',
    fechaFinal: '11-8-2026',
    direccion: 'la Arena',
    tamanio: '12 Hecateas',
    caracterizacion: 'Seco',
    estado: 'en alquiler',
  ),
];
