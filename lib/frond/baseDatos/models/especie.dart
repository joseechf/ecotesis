import 'dart:typed_data';

class Especie {
  String nombreCientifico;
  int? daSombra;
  String? florDistintiva;
  String? frutaDistintiva;
  int? saludSuelo;
  String? huespedes;
  String? formaCrecimiento;
  int? pionero;
  String? polinizador;
  String? ambiente;
  int? nativoAmerica;
  int? nativoPanama;
  int? nativoAzuero;
  String? estrato;

  List<NombreComun> nombresComunes;
  List<Utilidad> utilidades;
  List<Origen> origenes;
  List<Imagen> imagenes;

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
    this.nativoAmerica,
    this.nativoPanama,
    this.nativoAzuero,
    this.estrato,
    List<NombreComun>? nombresComunes,
    List<Utilidad>? utilidades,
    List<Origen>? origenes,
    List<Imagen>? imagenes,
  }) : nombresComunes = nombresComunes ?? [],
       utilidades = utilidades ?? [],
       origenes = origenes ?? [],
       imagenes = imagenes ?? [];

  factory Especie.jsonToEspecie(Map<String, dynamic> fila) {
    // split de cadenas (pueden ser null si no hay datos)
    List<String> split(String? s) =>
        s == null || s.trim().isEmpty
            ? <String>[]
            : s.split('|').map((e) => e.trim()).toList();
    // construye los vectores
    final nombresComunes =
        split(
          fila['nombres_comunes'],
        ).map((nom) => NombreComun(nombres: nom)).toList();

    final origenes =
        split(fila['origenes']).map((orig) => Origen(origen: orig)).toList();

    final utilidades =
        split(
          fila['utilidades'],
        ).map((util) => Utilidad(utilpara: util)).toList();

    final imagenes =
        split(fila['imagenes']).map((chunk) {
          final parts = chunk.split('@@');
          return Imagen(
            urlFoto: parts[0],
            estado: parts.length > 1 ? parts[1] : '',
          );
        }).toList();
    return Especie(
      nombreCientifico: fila['nombrecientifico'],
      daSombra: _parseBool(fila['dasombra']) ? 1 : 0,
      saludSuelo: _parseBool(fila['saludsuelo']) ? 1 : 0,
      pionero: _parseBool(fila['pionero']) ? 1 : 0,
      nativoAmerica: _parseBool(fila['nativoamerica:']) ? 1 : 0,
      nativoPanama: _parseBool(fila['nativopanama']) ? 1 : 0,
      nativoAzuero: _parseBool(fila['nativoazuero']) ? 1 : 0,
      florDistintiva: fila['flordistintiva:'] ?? '',
      frutaDistintiva: fila['frutadistintiva'] ?? '',
      huespedes: fila['huespedes'] ?? '',
      formaCrecimiento: fila['formacrecimiento'] ?? '',
      polinizador: fila['polinizador'] ?? '',
      ambiente: fila['ambiente'] ?? '',
      estrato: fila['estrato'] ?? '',
      nombresComunes: nombresComunes,
      utilidades: utilidades,
      origenes: origenes,
      imagenes: imagenes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'nombresComunes': nombresComunes.map((e) => e.toJson()).toList(),
      'utilidades': utilidades.map((e) => e.toJson()).toList(),
      'origenes': origenes.map((e) => e.toJson()).toList(),
      'imagenes': imagenes.map((e) => e.toJson()).toList(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is int) return value == 1;
    if (value is String) return value == '1';
    return false;
  }
}

class NombreComun {
  String nombres;

  NombreComun({required this.nombres});

  Map<String, dynamic> toJson() {
    return {'nombres': nombres};
  }
}

class Utilidad {
  String utilpara;

  Utilidad({required this.utilpara});

  Map<String, dynamic> toJson() {
    return {'utilpara': utilpara};
  }
}

class Origen {
  String origen;

  Origen({required this.origen});

  Map<String, dynamic> toJson() {
    return {'origen': origen};
  }
}

class Imagen {
  String urlFoto;
  String estado;

  Uint8List? bytes;

  Imagen({required this.urlFoto, required this.estado, this.bytes});

  Map<String, dynamic> toJson() => {'urlFoto': urlFoto, 'estado': estado};
}
