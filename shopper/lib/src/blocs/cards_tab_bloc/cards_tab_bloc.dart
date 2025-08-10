import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/models/card_model.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/cache/cards_cache_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/services/data/card_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';

part 'cards_tab_event.dart';
part 'cards_tab_state.dart';

class CardsTabBloc extends Bloc<CardsTabEvent, CardsTabState> {
  final ConnectionService connectionService;
  final CardService service;
  final CardsCacheService cacheService;

  CardsTabBloc({
    required this.connectionService,
    required this.service,
    required this.cacheService,
  }) : super(const CardsTabLoading()) {
    on<CardsTabEvent>((event, emit) async {
      switch (event) {
        case CardsTabLoadCards():
          await _onLoadCards(event, emit);
        case CardsTabAddCard():
          await _onAddCard(event, emit);
        case CardsTabUpdateCard():
          await _onUpdateCard(event, emit);
        case CardsTabRemoveCard():
          await _onRemoveCard(event, emit);
      }
    });
  }

  Future<void> _onLoadCards(
      CardsTabLoadCards event, Emitter<CardsTabState> emit) async {
    emit(const CardsTabLoading());

    final result = await cacheService.loadCardsFromCache();
    var localCards = <CardModel>[];
    if (result.isSuccess()) {
      localCards = result.tryGetSuccess()!;
      emit(CardsTabLoaded(localCards));
    } else {
      emit(CardsTabError(result.tryGetError()!.message));
      AnalyticsService.error('loadCardsCache', {
        'message': result.tryGetError()!.message,
      });
    }

    final isConnected = await connectionService.isConnected;
    if (isConnected) {
      final result = await service.loadCardsForUser(event.userId);
      var remoteCards = <CardModel>[];
      if (result.isSuccess()) {
        remoteCards = result.tryGetSuccess()!;
        if (!listEquals(
          localCards
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            ),
          remoteCards
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            ),
        )) {
          localCards.removeWhere((element) => !remoteCards.contains(element));
          final difference =
              remoteCards.toSet().difference(localCards.toSet()).toList();

          final idsToDelete = difference.map((e) => e.id).toList();
          await cacheService.removeAllWithIdsFromCache(idsToDelete);

          event.deleteItems(idsToDelete);
          event.addItems(difference);

          await cacheService.addAllCards(remoteCards);
        }
      } else {
        AnalyticsService.error('loadCardsOnline', {
          'message': result.tryGetError()!.message,
        });
      }
    }
  }

  Future<void> _onAddCard(
      CardsTabAddCard event, Emitter<CardsTabState> emit) async {
    emit(const CardsTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final result = await service.createCard(event.card);

    if (result.isSuccess()) {
      await cacheService.addCardToCache(event.card);
      event.success(event.card);
    } else {
      AnalyticsService.error('addCard', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onUpdateCard(
      CardsTabUpdateCard event, Emitter<CardsTabState> emit) async {
    emit(const CardsTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final result = await service.updateCard(event.card);

    if (result.isSuccess()) {
      await cacheService.updateCardInCache(event.card);
      event.success(event.card);
    } else {
      AnalyticsService.error('updateCard', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onRemoveCard(
      CardsTabRemoveCard event, Emitter<CardsTabState> emit) async {
    emit(const CardsTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final result = await service.deleteCard(event.cardId);

    if (result.isSuccess()) {
      await cacheService.removeCardFromCache(event.cardId);
      event.success(event.cardId);
    } else {
      AnalyticsService.error('onRemoveCard', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }
}
