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
    nombreCientifico: r['nombreCientifico'],
    daSombra: r['daSombra'],
    florDistintiva: r['florDistintiva'],
    frutaDistintiva: r['frutaDistintiva'],
    saludSuelo: r['saludSuelo'],
    huespedes: r['huespedes'],
    formaCrecimiento: r['formaCrecimiento'],
    pionero: r['pionero'],
    polinizador: r['polinizador'],
    ambiente: r['ambiente'],
    nativoAmerica: r['nativoAmerica'],
    nativoPanama: r['nativoPanama'],
    nativoAzuero: r['nativoAzuero'],
    estrato: r['estrato'],
  );

  /// de objeto → row SQLite
  Map<String, dynamic> toRow() => {
    'nombreCientifico': nombreCientifico,
    'daSombra': daSombra,
    'florDistintiva': florDistintiva,
    'frutaDistintiva': frutaDistintiva,
    'saludSuelo': saludSuelo,
    'huespedes': huespedes,
    'formaCrecimiento': formaCrecimiento,
    'pionero': pionero,
    'polinizador': polinizador,
    'ambiente': ambiente,
    'nativoAmerica': nativoAmerica,
    'nativoPanama': nativoPanama,
    'nativoAzuero': nativoAzuero,
    'estrato': estrato,
  };
}
