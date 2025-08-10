import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/shopping_list_item_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShoppingListItemService {
  final SupabaseClient database;
  late RealtimeChannel _activeChannel;

  ShoppingListItemService({
    required this.database,
  });

  void initializeRealtimeListeners({
    required String filterListId,
    required Future<void> Function(Map<String, dynamic> payloadMap) onInsert,
    required Future<void> Function(Map<String, dynamic> payloadMap) onUpdate,
    required Future<void> Function(Map<String, dynamic> payloadMap) onDelete,
  }) async {
    _activeChannel = database
        .channel('public:shopping_list_item')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'shopping_list_item',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'shopping_list_id',
            value: filterListId,
          ),
          callback: (payload) async => await onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'shopping_list_item',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'shopping_list_id',
            value: filterListId,
          ),
          callback: (payload) async => await onUpdate(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'shopping_list_item',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'shopping_list_id',
            value: filterListId,
          ),
          callback: (payload) async {
            if (payload.oldRecord['shopping_list_id'] != filterListId) return;
            await onDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  Future<void> removeRealtimeListeners() async {
    await database.removeChannel(_activeChannel);
  }

  Future<Result<Unit, BaseException>> createListItem(
      ShoppingListItemModel newItem) async {
    try {
      final map = newItem.toMap();
      await database.from('shopping_list_item').insert(map);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> deleteListItem(String listItemId) async {
    try {
      await database.from('shopping_list_item').delete().eq('id', listItemId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> updateListItem(
      ShoppingListItemModel newItem) async {
    try {
      final map = newItem.toMap();
      map.remove('id');
      await database
          .from('shopping_list_item')
          .update(map)
          .eq('id', newItem.id);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> markListItem(
      String itemId, bool newSelectionState) async {
    try {
      await database
          .from('shopping_list_item')
          .update({'is_done': newSelectionState}).eq('id', itemId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<ShoppingListItemModel>, BaseException>>
      loadListItemsForList(String listId) async {
    try {
      final data = await database
          .from('shopping_list_item')
          .select()
          .eq('shopping_list_id', listId);
      final shoppingListItems =
          data.map((e) => ShoppingListItemModel.fromMap(e)).toList()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
      return Success(shoppingListItems);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> deleteAllListItems(String listId) async {
    try {
      await database
          .from('shopping_list_item')
          .delete()
          .eq('shopping_list_id', listId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
