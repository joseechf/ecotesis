Map<String, dynamic> adaptarRemotoAJsonDominio(Map<String, dynamic> remoto) {
  return {
    ...remoto,

    'NombreComun':
        remoto['nombre_comun'] != null
            ? [
              {'nombre_comun': remoto['nombre_comun']},
            ]
            : [],

    'Utilidad':
        remoto['utilidad'] != null
            ? remoto['utilidad']
                .toString()
                .split('|')
                .map((u) => {'utilidad': u})
                .toList()
            : [],

    'Origen':
        remoto['origen'] != null
            ? [
              {'origen': remoto['origen']},
            ]
            : [],

    'Imagen': [],
  };
}
