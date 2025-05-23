class Item {
  final String id;
  final String name;
  final String tipo;
  final String ultAct;
  final bool sincronizado;

  Item({
    required this.id,
    required this.name,
    required this.tipo,
    required this.ultAct,
    this.sincronizado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tipo': tipo,
      'ultAct': ultAct,
      'sincronizado': sincronizado ? 1 : 0,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      tipo: map['tipo'],
      ultAct: map['ultAct'],
      sincronizado: map['sincronizado'] == 1,
    );
  }
}
