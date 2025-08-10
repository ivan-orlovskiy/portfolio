part of 'cards_tab_bloc.dart';

sealed class CardsTabEvent extends Equatable {
  const CardsTabEvent();

  @override
  List<Object> get props => [];
}

final class CardsTabLoadCards extends CardsTabEvent {
  final String userId;
  final Function(List<String> ids) deleteItems;
  final Function(List<CardModel> cards) addItems;

  const CardsTabLoadCards(this.userId, this.deleteItems, this.addItems);

  @override
  List<Object> get props => [userId, deleteItems, addItems];
}

final class CardsTabAddCard extends CardsTabEvent {
  final CardModel card;
  final Function(CardModel card) success;
  final Function(String errorMessage) error;

  const CardsTabAddCard(this.card, this.success, this.error);

  @override
  List<Object> get props => [card, success, error];
}

final class CardsTabUpdateCard extends CardsTabEvent {
  final CardModel card;
  final Function(CardModel card) success;
  final Function(String errorMessage) error;

  const CardsTabUpdateCard(this.card, this.success, this.error);

  @override
  List<Object> get props => [card, success, error];
}

final class CardsTabRemoveCard extends CardsTabEvent {
  final String cardId;
  final Function(String cardId) success;
  final Function(String errorMessage) error;

  const CardsTabRemoveCard(this.cardId, this.success, this.error);

  @override
  List<Object> get props => [cardId, success, error];
}
