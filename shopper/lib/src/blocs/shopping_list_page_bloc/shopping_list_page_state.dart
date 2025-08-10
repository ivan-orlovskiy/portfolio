part of 'shopping_list_page_bloc.dart';

sealed class ShoppingListPageState extends Equatable {
  const ShoppingListPageState();

  @override
  List<Object> get props => [];
}

final class ShoppingListPageLoading extends ShoppingListPageState {
  const ShoppingListPageLoading();
}

final class ShoppingListPageLoaded extends ShoppingListPageState {
  final List<ShoppingListItemModel> listItems;

  const ShoppingListPageLoaded(this.listItems);

  @override
  List<Object> get props => [listItems];
}

final class ShoppingListPageError extends ShoppingListPageState {
  final String message;

  const ShoppingListPageError(this.message);

  @override
  List<Object> get props => [message];
}
