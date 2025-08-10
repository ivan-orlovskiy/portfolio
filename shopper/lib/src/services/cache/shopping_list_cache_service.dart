import 'package:hive_flutter/hive_flutter.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/shopping_list_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';

class ShoppingListCacheService {
  final Box database;

  ShoppingListCacheService({
    required this.database,
  });

  Future<Result<Unit, BaseException>> addAllLists(
      List<ShoppingListModel> newLists) async {
    try {
      await database.clear();
      final mapOfNewLists =
          Map.fromEntries(newLists.map((e) => MapEntry(e.id, e.toMap())));
      await database.putAll(mapOfNewLists);
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

  Future<Result<Unit, BaseException>> addListToCache(
      ShoppingListModel newList) async {
    try {
      await database.put(newList.id, newList.toMap());
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> updateListInCache(
      ShoppingListModel newList) async {
    try {
      await database.put(newList.id, newList.toMap());
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeListFromCache(String listId) async {
    try {
      await database.delete(listId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<ShoppingListModel>, BaseException>>
      loadListsFromCache() async {
    try {
      final lists = database.values
          .map((e) => ShoppingListModel.fromMap(e.cast<String, dynamic>()))
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
