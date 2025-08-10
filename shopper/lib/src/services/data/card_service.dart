import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/card_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CardService {
  final Uuid uuid;
  final SupabaseClient database;

  CardService({
    required this.uuid,
    required this.database,
  });

  Future<Result<Unit, BaseException>> createCard(CardModel newCard) async {
    try {
      final map = newCard.toMap();
      await database.from('card').insert(map);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> updateCard(CardModel newCard) async {
    try {
      final map = newCard.toMap();
      map.remove('id');
      await database.from('card').update(map).eq('id', newCard.id);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> deleteCard(String cardId) async {
    try {
      await database.from('card').delete().eq('id', cardId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<CardModel>, BaseException>> loadCardsForUser(String userId) async {
    try {
      final data = await database.from('card').select().eq('user_id', userId);
      final cards = data.map((e) => CardModel.fromMap(e)).toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      return Success(cards);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
