class CardModel {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String data;

  CardModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'data': data,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      data: map['data'] as String,
    );
  }

  CardModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? data,
  }) {
    return CardModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'CardModel(id: $id, userId: $userId, name: $name, icon: $icon, data: $data)';
  }

  @override
  bool operator ==(covariant CardModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.icon == icon &&
        other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ name.hashCode ^ icon.hashCode ^ data.hashCode;
  }
}
