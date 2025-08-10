import 'package:hive_flutter/hive_flutter.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/shopping_list_item_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';

class ShoppingListItemCacheService {
  final Box database;

  ShoppingListItemCacheService({
    required this.database,
  });

  Future<Result<Unit, BaseException>> addAllItems(
      List<ShoppingListItemModel> newItems) async {
    try {
      await database.clear();
      final mapOfNewItems =
          Map.fromEntries(newItems.map((e) => MapEntry(e.id, e.toMap())));
      await database.putAll(mapOfNewItems);
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

  Future<Result<Unit, BaseException>> addListItemToCache(
      ShoppingListItemModel newItem) async {
    try {
      await database.put(newItem.id, newItem.toMap());
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> markListItemInCache(
      String itemId, bool newState) async {
    try {
      final item = database.get(itemId);
      item['is_done'] = newState;
      await database.put(itemId, item);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeListItemFromCache(
      String itemId) async {
    try {
      await database.delete(itemId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeAllListItemsFromCacheForList(
      String listId) async {
    try {
      await database.deleteAll(database.values
          .where((element) => element['shopping_list_id'] == listId)
          .map((e) => e['id']));
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<ShoppingListItemModel>, BaseException>>
      loadListItemsFromCacheForList(String listId) async {
    try {
      final lists = database.values
          .where((element) => element['shopping_list_id'] == listId)
          .map((e) => ShoppingListItemModel.fromMap(e.cast<String, dynamic>()))
          .toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      return Success(lists);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
