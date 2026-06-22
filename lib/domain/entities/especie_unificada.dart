import 'dart:convert';

import '../value_objects.dart';

class Especie {
  final String nombre_cientifico;
  final int? da_sombra;
  final String? flor_distintiva;
  final String? fruta_distintiva;
  final int? salud_suelo;
  final String? huespedes;
  final String? forma_crecimiento;
  final int? pionero;
  final String? polinizador;
  final String? ambiente;
  final String? establecido_sol_sombra;
  final int? nativo_america;
  final int? nativo_panama;
  final int? nativo_azuero;
  final String? estrato;
  final double? cobertura;

  final List<NombreComun> nombresComunes;
  final List<Utilidad> utilidades;
  final List<Origen> origenes;
  final List<ImagenTemp> imagenes;

  Especie({
    required this.nombre_cientifico,
    this.da_sombra,
    this.flor_distintiva,
    this.fruta_distintiva,
    this.salud_suelo,
    this.huespedes,
    this.forma_crecimiento,
    this.pionero,
    this.polinizador,
    this.ambiente,
    this.establecido_sol_sombra,
    this.nativo_america,
    this.nativo_panama,
    this.nativo_azuero,
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
   int? da_sombra,
   String? flor_distintiva,
   String? fruta_distintiva,
   int? salud_suelo,
   String? huespedes,
   String? forma_crecimiento,
   int? pionero,
   String? polinizador,
   String? ambiente,
   String? establecido_sol_sombra,
   int? nativo_america,
   int? nativo_panama,
   int? nativo_azuero,
   String? estrato,
   double? cobertura,

   List<NombreComun>? nombresComunes,
   List<Utilidad>? utilidades,
   List<Origen>? origenes,
   List<ImagenTemp>? imagenes,
  }){
    return Especie(
      nombre_cientifico: nombre_cientifico,
      da_sombra: da_sombra ?? this.da_sombra,
      flor_distintiva: flor_distintiva ?? this.flor_distintiva,
      fruta_distintiva: fruta_distintiva ?? this.fruta_distintiva,
      salud_suelo: salud_suelo ?? this.salud_suelo,
      huespedes: huespedes ?? this.huespedes,
      forma_crecimiento: forma_crecimiento ?? this.forma_crecimiento,
      pionero: pionero ?? this.pionero,
      polinizador: polinizador ?? this.polinizador,
      ambiente: ambiente ?? this.ambiente,
      establecido_sol_sombra: establecido_sol_sombra ?? this.establecido_sol_sombra,
      nativo_america: nativo_america ?? this.nativo_america,
      nativo_panama: nativo_panama ?? this.nativo_panama,
      nativo_azuero: nativo_azuero ?? this.nativo_azuero,
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
      nombre_cientifico: json['nombre_cientifico'] as String,
      da_sombra: json['da_sombra'] as int?,
      flor_distintiva: json['flor_distintiva'] as String?,
      fruta_distintiva: json['fruta_distintiva'] as String?,
      salud_suelo: json['salud_suelo'] as int?,
      huespedes: json['huespedes'] as String?,
      forma_crecimiento: json['forma_crecimiento'] as String?,
      pionero: json['pionero'] as int?,
      polinizador: json['polinizador'] as String?,
      ambiente: json['ambiente'] as String?,
      establecido_sol_sombra: json['establecido_sol_sombra'] as String?,
      nativo_america: json['nativo_america'] as int?,
      nativo_panama: json['nativo_panama'] as int?,
      nativo_azuero: json['nativo_azuero'] as int?,
      estrato: json['estrato'] as String?,
      cobertura: double.tryParse(json['cobertura']?.toString()?? '') ?? 0,

      nombresComunes:
        _parseJsonList(json['NombreComun']).
          map(NombreComun.fromMap).toList(),
      utilidades: 
          _parseJsonList(json['Utilidad']).
          map(Utilidad.fromMap).toList(),
      origenes: 
          _parseJsonList(json['Origen']).
          map(Origen.fromMap).toList(),
      imagenes: 
          _parseJsonList(json['Imagen']).
          map(ImagenTemp.fromMap).toList(),
    );
  }

  Map<String,dynamic>toJson(){
    return{
      'nombre_cientifico': nombre_cientifico,
      'da_sombra': da_sombra,
      'flor_distintiva': flor_distintiva,
      'fruta_distintiva': fruta_distintiva,
      'salud_suelo': salud_suelo,
      'huespedes': huespedes,
      'forma_crecimiento': forma_crecimiento,
      'pionero': pionero,
      'polinizador': polinizador,
      'ambiente': ambiente,
      'establecido_sol_sombra': establecido_sol_sombra,
      'nativo_america': nativo_america,
      'nativo_panama': nativo_panama,
      'nativo_azuero': nativo_azuero,
      'estrato': estrato,
      'cobertura': cobertura,

      'NombreComun': nombresComunes.map((e) => e.toMap()).toList(),
      'Utilidad': utilidades.map((e) => e.toMap()).toList(),
      'Origen': origenes.map((e) => e.toMap()).toList(),
      'Imagen': imagenes.map((e) => e.toMap()).toList(),
    };
  }


  // solo guarda la parte raiz (tabla flora)
  Map<String, dynamic> toDbRow(){
    return{
      'nombre_cientifico': nombre_cientifico,
      'da_sombra': da_sombra,
      'flor_distintiva': flor_distintiva,
      'fruta_distintiva': fruta_distintiva,
      'salud_suelo': salud_suelo,
      'huespedes': huespedes,
      'forma_crecimiento': forma_crecimiento,
      'pionero': pionero,
      'polinizador': polinizador,
      'ambiente': ambiente,
      'establecido_sol_sombra': establecido_sol_sombra,
      'nativo_america': nativo_america,
      'nativo_panama': nativo_panama,
      'nativo_azuero': nativo_azuero,
      'estrato': estrato,
      'cobertura': cobertura,
    };
  }

  static List<Map<String, dynamic>> _parseJsonList(dynamic value){
    if(value == null) return [];
    if(value is List){
      return value.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    final decoded = jsonDecode(value.toString());
    if(decoded is List){
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

}