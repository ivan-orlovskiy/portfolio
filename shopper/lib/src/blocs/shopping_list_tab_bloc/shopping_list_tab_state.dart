part of 'shopping_list_tab_bloc.dart';

sealed class ShoppingListTabState extends Equatable {
  const ShoppingListTabState();

  @override
  List<Object> get props => [];
}

final class ShoppingListTabLoading extends ShoppingListTabState {
  const ShoppingListTabLoading();
}

final class ShoppingListTabLoaded extends ShoppingListTabState {
  final List<ShoppingListModel> lists;

  const ShoppingListTabLoaded(this.lists);

  @override
  List<Object> get props => [lists];
}

final class ShoppingListTabError extends ShoppingListTabState {
  final String message;

  const ShoppingListTabError(this.message);

  @override
  List<Object> get props => [message];
}
