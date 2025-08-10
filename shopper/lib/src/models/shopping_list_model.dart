class ShoppingListModel {
  final String id;
  final String ownerId;
  final String ownerNickname;
  final String name;
  final String icon;

  ShoppingListModel({
    required this.id,
    required this.ownerNickname,
    required this.ownerId,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner_id': ownerId,
      'owner_nickname': ownerNickname,
      'name': name,
      'icon': icon,
    };
  }

  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'] as String,
      ownerId: map['owner_id'] as String,
      ownerNickname: map['owner_nickname'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
    );
  }

  @override
  String toString() {
    return 'ShoppingListModel(id: $id, ownerId: $ownerId, ownerNickname: $ownerNickname, name: $name, icon: $icon)';
  }
}
