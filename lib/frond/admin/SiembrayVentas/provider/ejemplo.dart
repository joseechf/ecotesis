import 'bdFake/models.dart';

final List<Siembra> paraSiembra = [
  Siembra(
    idSiembra: '1',
    nombreLatino: 'Especie A',
    cantDisponible: 10,
    forma: 'semilla',
  ),
  Siembra(
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

final List<RSiembra> sembrados = [
  RSiembra(
    idRegistro: 'siembra1',
    idSiembra: '1',
    nombreLatino: 'Especie A',
    idUsuario: '1',
    nombreUsuario: 'Juan',
    fechaPlantacion: '10-11-2025',
    fechaBrote: '10-12-2026',
    cantidad: 2,
    coordenadas: '{Lat: 123,123, Lon: 456,654}',
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
