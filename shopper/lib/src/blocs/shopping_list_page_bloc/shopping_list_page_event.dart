part of 'shopping_list_page_bloc.dart';

sealed class ShoppingListPageEvent extends Equatable {
  const ShoppingListPageEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListPageLoadItems extends ShoppingListPageEvent {
  final String listId;

  const ShoppingListPageLoadItems(this.listId);

  @override
  List<Object> get props => [listId];
}

final class ShoppingListPageAddItem extends ShoppingListPageEvent {
  final ShoppingListItemModel item;
  final Function(String errorMessage) restore;

  const ShoppingListPageAddItem(this.item, this.restore);

  @override
  List<Object> get props => [item, restore];
}

final class ShoppingListPageRemoveItem extends ShoppingListPageEvent {
  final String itemId;
  final Function(String errorMessage) restore;

  const ShoppingListPageRemoveItem(this.itemId, this.restore);

  @override
  List<Object> get props => [itemId, restore];
}

final class ShoppingListPageRemoveAllItems extends ShoppingListPageEvent {
  final String listId;
  final Function(String errorMessage) restore;

  const ShoppingListPageRemoveAllItems(this.listId, this.restore);

  @override
  List<Object> get props => [listId, restore];
}

final class ShoppingListPageMarkItem extends ShoppingListPageEvent {
  final String itemId;
  final bool newState;
  final Function(String errorMessage) restore;

  const ShoppingListPageMarkItem(this.itemId, this.newState, this.restore);

  @override
  List<Object> get props => [itemId, newState, restore];
}
