// lib/data/models/especie_db.dart
class EspecieDb {
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

  const EspecieDb({
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
  });

  /// de row SQLite → objeto
  factory EspecieDb.fromRow(Map<String, dynamic> r) => EspecieDb(
    nombreCientifico: r['nombre_cientifico'],
    daSombra: r['da_sombra'],
    florDistintiva: r['flor_distintiva'],
    frutaDistintiva: r['fruta_distintiva'],
    saludSuelo: r['salud_suelo'],
    huespedes: r['huespedes'],
    formaCrecimiento: r['forma_crecimiento'],
    pionero: r['pionero'],
    polinizador: r['polinizador'],
    ambiente: r['ambiente'],
    nativoAmerica: r['nativo_america'],
    nativoPanama: r['nativo_panama'],
    nativoAzuero: r['nativo_azuero'],
    estrato: r['estrato'],
  );

  /// de objeto → row SQLite
  Map<String, dynamic> toRow() => {
    'nombre_cientifico': nombreCientifico,
    'da_sombra': daSombra,
    'flor_distintiva': florDistintiva,
    'fruta_distintiva': frutaDistintiva,
    'salud_suelo': saludSuelo,
    'huespedes': huespedes,
    'forma_crecimiento': formaCrecimiento,
    'pionero': pionero,
    'polinizador': polinizador,
    'ambiente': ambiente,
    'nativo_america': nativoAmerica,
    'nativo_panama': nativoPanama,
    'nativo_azuero': nativoAzuero,
    'estrato': estrato,
  };
}
