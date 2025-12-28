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
    return Especie(
      nombreCientifico: fila['nombrecientifico'],
      daSombra: fila['daSombra'] == '1' ? 1 : 0,
      saludSuelo: fila['saludSuelo'] == '1' ? 1 : 0,
      florDistintiva: fila['florDistintiva'] ?? '',
      frutaDistintiva: fila['frutaDistintiva'] ?? '',
      huespedes: fila['huespedes'] ?? '',
      formaCrecimiento: fila['formaCrecimiento'] ?? '',
      pionero: fila['pionero'] == '1' ? 1 : 0,
      polinizador: fila['polinizador'] ?? '',
      ambiente: fila['ambiente'] ?? '',
      nativoAmerica: fila['nativoAmerica'] == '1' ? 1 : 0,
      nativoPanama: fila['nativoPanama'] == '1' ? 1 : 0,
      nativoAzuero: fila['nativoAzuero'] == '1' ? 1 : 0,
      estrato: fila['estrato'] ?? '',
      /* imagenes.add(
        Imagen(urlFoto: 'assets/images/calabazo.jpeg', estado: 'tentativo'),
      ),*/
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
