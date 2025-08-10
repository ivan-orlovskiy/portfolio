class ShoppingListUserModel {
  final String id;
  final String shoppingListId;
  final String userId;
  final String userNickname;

  ShoppingListUserModel({
    required this.id,
    required this.shoppingListId,
    required this.userId,
    required this.userNickname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopping_list_id': shoppingListId,
      'user_id': userId,
      'user_nickname': userNickname,
    };
  }

  factory ShoppingListUserModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListUserModel(
      id: map['id'] as String,
      shoppingListId: map['shopping_list_id'] as String,
      userId: map['user_id'] as String,
      userNickname: map['user_nickname'] as String,
    );
  }
}
