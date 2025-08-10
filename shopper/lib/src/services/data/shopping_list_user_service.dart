import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/models/shopping_list_user_model.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ShoppingListUserService {
  final SupabaseClient database;
  final Uuid uuid;
  late RealtimeChannel _activeChannel;

  ShoppingListUserService({
    required this.database,
    required this.uuid,
  });

  void initializeRealtimeListeners({
    required String listId,
    required Function(Map<String, dynamic> payloadMap) onInsert,
    required Function(Map<String, dynamic> payloadMap) onDelete,
  }) async {
    _activeChannel = database
        .channel('public:shopping_list_user_participants')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'shopping_list_user',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'shopping_list_id',
            value: listId,
          ),
          callback: (payload) async => onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'shopping_list_user',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'shopping_list_id',
            value: listId,
          ),
          callback: (payload) async {
            if (payload.oldRecord['shopping_list_id'] != listId) return;
            return onDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  Future<void> removeRealtimeListeners() async {
    await database.removeChannel(_activeChannel);
  }

  Future<Result<ShoppingListUserModel, BaseException>> addUserToList(
      String userNickname, String listId) async {
    try {
      final sameRecordList = await database
          .from('shopping_list_user')
          .select()
          .eq('user_nickname', userNickname)
          .eq('shopping_list_id', listId);
      if (sameRecordList.isNotEmpty) {
        return Error(BaseException(message: Lang.userExistsInTheList));
      }

      final userIdList =
          await database.from('user').select('id').eq('nickname', userNickname);
      if (userIdList.isEmpty) {
        return Error(BaseException(message: Lang.noSuchUser));
      }

      final userId = userIdList.first['id'] as String;
      final map = {
        'id': uuid.v4(),
        'shopping_list_id': listId,
        'user_id': userId,
        'user_nickname': userNickname,
      };
      await database.from('shopping_list_user').insert(map);
      return Success(ShoppingListUserModel.fromMap(map));
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> removeUserFromList(
      String recordId) async {
    try {
      await database.from('shopping_list_user').delete().eq('id', recordId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> quitFromList(
      String listId, String userId) async {
    try {
      await database
          .from('shopping_list_user')
          .delete()
          .eq('user_id', userId)
          .eq('shopping_list_id', listId);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<List<ShoppingListUserModel>, BaseException>> loadUsersForList(
      String listId) async {
    try {
      final data = await database
          .from('shopping_list_user')
          .select()
          .eq('shopping_list_id', listId);
      final shoppingListUsers =
          data.map((e) => ShoppingListUserModel.fromMap(e)).toList()
            ..sort(
              (a, b) => a.userNickname.compareTo(b.userNickname),
            );
      return Success(shoppingListUsers);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
