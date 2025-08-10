import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/shopping_list_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ShoppingListService {
  final SupabaseClient database;
  final Uuid uuid;
  late RealtimeChannel _activeChannel;

  ShoppingListService({
    required this.database,
    required this.uuid,
  });

  void initializeRealtimeListeners({
    required String userId,
    required Future<void> Function(Map<String, dynamic> payloadMap) onInsert,
    required Future<void> Function(Map<String, dynamic> payloadMap) onDelete,
  }) async {
    _activeChannel = database
        .channel('public:shopping_list_user')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'shopping_list_user',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            final newList = await database
                .from('shopping_list')
                .select()
                .eq('id', payload.newRecord['shopping_list_id'])
                .single();
            await onInsert(newList);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'shopping_list_user',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            if (payload.oldRecord['user_id'] != userId) return;
            await onDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  Future<void> removeRealtimeListeners() async {
    await database.removeChannel(_activeChannel);
  }

  Future<Result<Unit, BaseException>> createList(
      String userNickname, String userId, ShoppingListModel newList) async {
    try {
      final map = newList.toMap();
      await database.from('shopping_list').insert(map);

      final recordMap = {
        'id': uuid.v4(),
        'shopping_list_id': map['id'],
        'user_id': userId,
        'user_nickname': userNickname,
      };
      await database.from('shopping_list_user').insert(recordMap);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: 'message'));
    }
  }

  Future<Result<Unit, BaseException>> deleteList(String listId) async {
    try {
      await database.from('shopping_list').delete().eq('id', listId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> updateList(ShoppingListModel newList) async {
    try {
      final map = newList.toMap();
      map.remove('id');
      await database.from('shopping_list').update(map).eq('id', newList.id);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<ShoppingListModel>, BaseException>> loadListsForUser(String userId) async {
    try {
      final data = await database
          .from('shopping_list_user')
          .select('*, shopping_list(*)')
          .eq('user_id', userId);
      final shoppingLists = data.map((e) => ShoppingListModel.fromMap(e['shopping_list'])).toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      return Success(shoppingLists);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
