part of 'shopping_list_tab_bloc.dart';

sealed class ShoppingListTabEvent extends Equatable {
  const ShoppingListTabEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListTabLoadLists extends ShoppingListTabEvent {
  final String userId;

  const ShoppingListTabLoadLists(this.userId);

  @override
  List<Object> get props => [userId];
}

final class ShoppingListTabAddList extends ShoppingListTabEvent {
  final ShoppingListModel list;
  final Function(ShoppingListModel list) success;
  final Function(String errorMessage) error;

  const ShoppingListTabAddList(this.list, this.success, this.error);

  @override
  List<Object> get props => [list, success, error];
}

final class ShoppingListTabUpdateList extends ShoppingListTabEvent {
  final ShoppingListModel list;
  final Function(ShoppingListModel list) success;
  final Function(String errorMessage) error;

  const ShoppingListTabUpdateList(this.list, this.success, this.error);

  @override
  List<Object> get props => [list, success, error];
}

final class ShoppingListTabRemoveList extends ShoppingListTabEvent {
  final String listId;
  final Function(String listId) success;
  final Function(String errorMessage) error;

  const ShoppingListTabRemoveList(this.listId, this.success, this.error);

  @override
  List<Object> get props => [listId, success, error];
}

final class ShoppingListTabQuitFromList extends ShoppingListTabEvent {
  final String listId;
  final Function(String listId) success;
  final Function(String errorMessage) error;

  const ShoppingListTabQuitFromList(this.listId, this.success, this.error);

  @override
  List<Object> get props => [listId, success, error];
}
