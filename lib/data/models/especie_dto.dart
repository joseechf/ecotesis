import '../../domain/value_objects.dart';

class EspecieDto {
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

  final List<NombreComun>? nombresComunes;
  final List<Utilidad>? utilidades;
  final List<Origen>? origenes;
  final List<ImagenTemp>? imagenes;

  const EspecieDto({
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
    this.nombresComunes,
    this.utilidades,
    this.origenes,
    this.imagenes,
  });

  /// ---------- FROM JSON (API → APP) ----------
  factory EspecieDto.fromJson(Map<String, dynamic> json) {
    return EspecieDto(
      nombreCientifico: json['nombre_cientifico'] as String,
      daSombra: json['da_sombra'] as int?,
      florDistintiva: json['flor_distintiva'] as String?,
      frutaDistintiva: json['fruta_distintiva'] as String?,
      saludSuelo: json['salud_suelo'] as int?,
      huespedes: json['huespedes'] as String?,
      formaCrecimiento: json['forma_crecimiento'] as String?,
      pionero: json['pionero'] as int?,
      polinizador: json['polinizador'] as String?,
      ambiente: json['ambiente'] as String?,
      nativoAmerica: json['nativo_america'] as int?,
      nativoPanama: json['nativo_panama'] as int?,
      nativoAzuero: json['nativo_azuero'] as int?,
      estrato: json['estrato'] as String?,

      nombresComunes:
          (json['NombreComun'] as List<dynamic>?)
              ?.map(
                (e) => NombreComun(nombreComun: e['nombre_comun'] as String),
              )
              .toList(),

      utilidades:
          (json['Utilidad'] as List<dynamic>?)
              ?.map((e) => Utilidad(utilidad: e['utilidad'] as String))
              .toList(),

      origenes:
          (json['Origen'] as List<dynamic>?)
              ?.map((e) => Origen(origen: e['origen'] as String))
              .toList(),

      imagenes:
          (json['Imagen'] as List<dynamic>?)
              ?.map(
                (e) => ImagenTemp(
                  urlFoto: e['url_foto'] as String,
                  estado: e['estado'] as String,
                ),
              )
              .toList(),
    );
  }

  /// ---------- TO JSON (APP → API) ----------
  Map<String, dynamic> toJson() {
    return {
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

      'NombreComun':
          nombresComunes?.map((e) => {'nombre_comun': e.nombreComun}).toList(),

      'Utilidad': utilidades?.map((e) => {'utilidad': e.utilidad}).toList(),

      'Origen': origenes?.map((e) => {'origen': e.origen}).toList(),

      'Imagen':
          imagenes
              ?.map((e) => {'url_foto': e.urlFoto, 'estado': e.estado})
              .toList(),
    };
  }
}
