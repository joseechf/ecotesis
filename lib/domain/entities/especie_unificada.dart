import '../value_objects.dart';

class Especie {
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
  final String? establecidoSolSombra;
  final int? nativoAmerica;
  final int? nativoPanama;
  final int? nativoAzuero;
  final String? estrato;
  final double? cobertura;

  final List<NombreComun> nombresComunes;
  final List<Utilidad> utilidades;
  final List<Origen> origenes;
  final List<ImagenTemp> imagenes;

  Especie({
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
    this.establecidoSolSombra,
    this.nativoAmerica,
    this.nativoPanama,
    this.nativoAzuero,
    this.estrato,
    this.cobertura,
    List<NombreComun> nombresComunes = const [],
    List<Utilidad> utilidades = const [],
    List<Origen> origenes = const [],
    List<ImagenTemp> imagenes = const [],
  }) : assert(nombresComunes.length <= 50, 'Maximo de 50 nombres comunes'),
       assert(utilidades.length <= 20, 'Maximo de 20 utilidades'),
       assert(origenes.length <= 10, 'Maximo de 10 origenes'),
       assert(imagenes.length <= 5, 'Maximo de 5 imagenes'),
       nombresComunes = List.unmodifiable(nombresComunes),
       utilidades = List.unmodifiable(utilidades),
       origenes = List.unmodifiable(origenes),
       imagenes = List.unmodifiable(imagenes);

  Especie copyWith({
   int? daSombra,
   String? florDistintiva,
   String? frutaDistintiva,
   int? saludSuelo,
   String? huespedes,
   String? formaCrecimiento,
   int? pionero,
   String? polinizador,
   String? ambiente,
   String? establecidoSolSombra,
   int? nativoAmerica,
   int? nativoPanama,
   int? nativoAzuero,
   String? estrato,
   double? cobertura,

   List<NombreComun>? nombresComunes,
   List<Utilidad>? utilidades,
   List<Origen>? origenes,
   List<ImagenTemp>? imagenes,
  }){
    return Especie(
      nombreCientifico: nombreCientifico,
      daSombra: daSombra ?? this.daSombra,
      florDistintiva: florDistintiva ?? this.florDistintiva,
      frutaDistintiva: florDistintiva ?? this.frutaDistintiva,
      saludSuelo: saludSuelo ?? this.saludSuelo,
      huespedes: huespedes ?? this.huespedes,
      formaCrecimiento: formaCrecimiento ?? this.formaCrecimiento,
      pionero: pionero ?? this.pionero,
      polinizador: polinizador ?? this.polinizador,
      ambiente: ambiente ?? this.ambiente,
      establecidoSolSombra: establecidoSolSombra ?? this.establecidoSolSombra,
      nativoAmerica: nativoAmerica ?? this.nativoAmerica,
      nativoPanama: nativoAmerica ?? this.nativoAmerica,
      nativoAzuero: nativoAzuero ?? this.nativoAzuero,
      estrato: estrato ?? this.estrato,
      cobertura: cobertura ?? this.cobertura,
      nombresComunes: nombresComunes ?? this.nombresComunes,
      utilidades: utilidades ?? this.utilidades,
      origenes: origenes ?? this.origenes,
      imagenes: imagenes ?? this.imagenes,
    );
  }

  // API (JSON)

  factory Especie.fromJson(Map<String, dynamic> json) {
    return Especie(
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
      establecidoSolSombra: json['establecido_sol_sombra'] as String?,
      nativoAmerica: json['nativo_america'] as int?,
      nativoPanama: json['nativo_panama'] as int?,
      nativoAzuero: json['nativo_azuero'] as int?,
      estrato: json['estrato'] as String?,
      cobertura: double.tryParse(json['cobertura']?.toString()?? '') ?? 0,

      nombresComunes:
        (json['NombreComun'] as List<dynamic>?)
          ?.map(
            (e) => NombreComun(nombreComun: e['nombre_comun'] as String),
          ).toList() ?? const [],
      utilidades: 
          (json['Utilidad'] as List<dynamic>?)
            ?.map((e) => Utilidad(utilidad: e['utilidad'] as String),)
            .toList() ?? const [],
      origenes: 
          (json['Origen'] as List<dynamic>?)
            ?.map((e) => Origen(origen: e['origen'] as String),)
            .toList() ?? const [],
      imagenes: 
          (json['Imagen'] as List<dynamic>?)
              ?.map((e)=> ImagenTemp(
                urlFoto: e['url_foto'] as String,
                estado: e['estado'] as String,
              ),
              )
              .toList() ??
              const [],
    );
  }

  Map<String,dynamic>toJson(){
    return{
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
      'establecido_sol_sombra': establecidoSolSombra,
      'nativo_america': nativoAmerica,
      'nativo_panama': nativoPanama,
      'nativo_azuero': nativoAzuero,
      'estrato': estrato,
      'cobertura': cobertura,

      'NombreComun': nombresComunes.map((e) => {'nombre_comun': e.nombreComun}).toList(),
      'Utilidad': utilidades.map((e) => {'utilidad': e.utilidad}).toList(),
      'Origen': origenes.map((e) => {'origen': e.origen}).toList(),
      'Imagen': imagenes.map((e) => {'url_foto': e.urlFoto, 'estado': e.estado}).toList(),
    };
  }

  // SQLITE
// contruye la especie base desde la tabla principal
// las listas se inyectan ya reconstruidas desde llamadas_flora
factory Especie.fromDbMap({
  required Map<String,dynamic> row,
  List<NombreComun> nombresComunes = const [],
  List<Utilidad> utilidades = const [],
  List<Origen> origenes = const [],
  List<ImagenTemp> imagenes = const [],
}){
  return Especie(
    nombreCientifico: row['nombre_cientifico'] as String,
    daSombra: row['da_sombra'] as int?,
    florDistintiva: row['flor_distintiva'] as String?,
    frutaDistintiva: row['fruta_distintiva'] as String?,
    saludSuelo: row['salud_suelo'] as int?,
    huespedes: row['huespedes'] as String?,
    formaCrecimiento: row['forma_crecimiento'] as String?,
    pionero: row['pionero'] as int?,
    polinizador: row['polinizador'] as String?,
    ambiente: row['ambiente'] as String?,
    establecidoSolSombra: row['establecido_sol_sombra'] as String?,
    nativoAmerica: row['nativo_america'] as int?,
    nativoPanama: row['nativo_panama'] as int?,
    nativoAzuero: row['nativo_azuero'] as int?,
    estrato: row['estrato'] as String?,
    cobertura: row['cobertura'] as double?,
    nombresComunes: nombresComunes,
    utilidades: utilidades,
    origenes: origenes,
    imagenes: imagenes,
  );
}

  // solo guarda la parte raiz (tabla flora)
  Map<String, dynamic> toDbRow(){
    return{
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
      'establecido_sol_sombra': establecidoSolSombra,
      'nativo_america': nativoAmerica,
      'nativo_panama': nativoPanama,
      'nativo_azuero': nativoAzuero,
      'estrato': estrato,
      'cobertura': cobertura,
    };
  }

}