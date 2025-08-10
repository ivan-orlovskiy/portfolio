part of 'cards_tab_bloc.dart';

sealed class CardsTabState extends Equatable {
  const CardsTabState();

  @override
  List<Object> get props => [];
}

final class CardsTabLoading extends CardsTabState {
  const CardsTabLoading();
}

final class CardsTabLoaded extends CardsTabState {
  final List<CardModel> cards;

  const CardsTabLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

final class CardsTabError extends CardsTabState {
  final String message;

  const CardsTabError(this.message);

  @override
  List<Object> get props => [message];
}
