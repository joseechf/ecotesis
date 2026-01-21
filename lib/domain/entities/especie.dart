import '../value_objects.dart';

class Especie {
  /// Identificador principal de la especie
  final String nombreCientifico;

  final int? daSombra;
  final String? florDistintiva;
  final String? frutaDistintiva;
  final int? saludSuelo;
  final String? huespedes;
  final String? formaCrecimiento;
  final int? pionero;
  final String? polinizador;
  final String? ambiente;
  final int? nativoAmerica;
  final int? nativoPanama;
  final int? nativoAzuero;
  final String? estrato;

  /// Relaciones 1-N
  final List<NombreComun> nombresComunes;
  final List<Utilidad> utilidades;
  final List<Origen> origenes;
  final List<ImagenTemp> imagenes;

  const Especie({
    required this.nombreCientifico,
    this.daSombra,
    this.florDistintiva,
    this.frutaDistintiva,
    this.saludSuelo,
    this.huespedes,
    this.formaCrecimiento,
    this.pionero,
    this.polinizador,
    this.ambiente,
    this.nativoAmerica,
    this.nativoPanama,
    this.nativoAzuero,
    this.estrato,
    this.nombresComunes = const [],
    this.utilidades = const [],
    this.origenes = const [],
    this.imagenes = const [],
  });
}
