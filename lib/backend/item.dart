class Item {
  final int? id;
  final String name;
  final String description;
  final bool isSynced;

  Item({
    this.id,
    required this.name,
    required this.description,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
