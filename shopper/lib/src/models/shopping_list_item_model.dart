class ShoppingListItemModel {
  final String id;
  final String shoppingListId;
  final String name;
  final String volume;
  bool isDone;

  ShoppingListItemModel({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.volume,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopping_list_id': shoppingListId,
      'name': name,
      'volume': volume,
      'is_done': isDone,
    };
  }

  factory ShoppingListItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListItemModel(
      id: map['id'] as String,
      shoppingListId: map['shopping_list_id'] as String,
      name: map['name'] as String,
      volume: map['volume'] as String,
      isDone: map['is_done'] as bool,
    );
  }

  ShoppingListItemModel copyWith({
    String? id,
    String? shoppingListId,
    String? name,
    String? volume,
    bool? isDone,
  }) {
    return ShoppingListItemModel(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      volume: volume ?? this.volume,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  String toString() {
    return 'ShoppingListItemModel(id: $id, shoppingListId: $shoppingListId, name: $name, volume: $volume, isDone: $isDone)';
  }

  @override
  bool operator ==(covariant ShoppingListItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.shoppingListId == shoppingListId &&
        other.name == name &&
        other.volume == volume &&
        other.isDone == isDone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        shoppingListId.hashCode ^
        name.hashCode ^
        volume.hashCode ^
        isDone.hashCode;
  }
}
