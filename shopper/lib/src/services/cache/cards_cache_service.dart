import 'package:hive_flutter/hive_flutter.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/card_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';

class CardsCacheService {
  final Box database;
  CardsCacheService({
    required this.database,
  });

  Future<Result<Unit, BaseException>> addAllCards(
      List<CardModel> newCards) async {
    try {
      await database.clear();
      final mapOfNewCards =
          Map.fromEntries(newCards.map((e) => MapEntry(e.id, e.toMap())));
      await database.putAll(mapOfNewCards);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> clearCache() async {
    try {
      await database.clear();
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> addCardToCache(CardModel newCard) async {
    try {
      await database.put(newCard.id, newCard.toMap());
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> updateCardInCache(
      CardModel newCard) async {
    try {
      await database.put(newCard.id, newCard.toMap());
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeCardFromCache(String cardId) async {
    try {
      await database.delete(cardId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeAllWithIdsFromCache(
      List<String> ids) async {
    try {
      await database.deleteAll(ids);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<CardModel>, BaseException>> loadCardsFromCache() async {
    try {
      final cards = database.values
          .map((e) => CardModel.fromMap(e.cast<String, dynamic>()))
          .toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      return Success(cards);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
