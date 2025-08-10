import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/models/shopping_list_model.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/services/cache/shopping_list_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_item_cache_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/services/data/shopping_list_service.dart';
import 'package:shopper/src/services/data/shopping_list_user_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';

part 'shopping_list_tab_event.dart';
part 'shopping_list_tab_state.dart';

class ShoppingListTabBloc
    extends Bloc<ShoppingListTabEvent, ShoppingListTabState> {
  final ConnectionService connectionService;
  final ShoppingListService service;
  final ShoppingListUserService userService;
  final ShoppingListCacheService listCacheService;
  final ShoppingListItemCacheService listItemCacheService;
  final AuthenticationService authenticationService;

  ShoppingListTabBloc({
    required this.connectionService,
    required this.service,
    required this.userService,
    required this.listCacheService,
    required this.listItemCacheService,
    required this.authenticationService,
  }) : super(const ShoppingListTabLoading()) {
    on<ShoppingListTabEvent>((event, emit) async {
      switch (event) {
        case ShoppingListTabLoadLists():
          await _onLoadLists(event, emit);
        case ShoppingListTabAddList():
          await _onAddList(event, emit);
        case ShoppingListTabUpdateList():
          await _onUpdateList(event, emit);
        case ShoppingListTabRemoveList():
          await _onRemoveList(event, emit);
        case ShoppingListTabQuitFromList():
          await _onQuitFromList(event, emit);
      }
    });
  }

  void initializeRealtimeListeners({
    required Function(Map<String, dynamic> payloadMap) onInsert,
    required Function(Map<String, dynamic> payloadMap) onDelete,
  }) {
    final userId = authenticationService.userId;
    service.initializeRealtimeListeners(
      userId: userId,
      onInsert: (payloadMap) async {
        onInsert(payloadMap);
        await listCacheService
            .addListToCache(ShoppingListModel.fromMap(payloadMap));
      },
      onDelete: (payloadMap) async {
        onDelete(payloadMap);
        await listCacheService.removeListFromCache(payloadMap['id']);
      },
    );
  }

  @override
  Future<void> close() async {
    await service.removeRealtimeListeners();
    super.close();
  }

  Future<void> _onLoadLists(ShoppingListTabLoadLists event,
      Emitter<ShoppingListTabState> emit) async {
    emit(const ShoppingListTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      final result = await listCacheService.loadListsFromCache();

      if (result.isSuccess()) {
        emit(ShoppingListTabLoaded(result.tryGetSuccess()!));
      } else {
        AnalyticsService.error('loadListsCache', {
          'message': result.tryGetError()!.message,
        });
        emit(ShoppingListTabError(result.tryGetError()!.message));
      }

      return;
    }

    final result = await service.loadListsForUser(event.userId);

    if (result.isSuccess()) {
      await listCacheService.addAllLists(result.tryGetSuccess()!);
      emit(ShoppingListTabLoaded(result.tryGetSuccess()!));
    } else {
      AnalyticsService.error('loadListsOnline', {
        'message': result.tryGetError()!.message,
      });
      emit(ShoppingListTabError(result.tryGetError()!.message));
    }
  }

  Future<void> _onAddList(
      ShoppingListTabAddList event, Emitter<ShoppingListTabState> emit) async {
    emit(const ShoppingListTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final userId = authenticationService.userId;
    final userNickname = authenticationService.userNickname;

    final result = await service.createList(userNickname, userId, event.list);

    if (result.isSuccess()) {
      await listCacheService.addListToCache(event.list);
      event.success(event.list);
    } else {
      AnalyticsService.error('addList', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onUpdateList(ShoppingListTabUpdateList event,
      Emitter<ShoppingListTabState> emit) async {
    emit(const ShoppingListTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final result = await service.updateList(event.list);

    if (result.isSuccess()) {
      await listCacheService.updateListInCache(event.list);
      event.success(event.list);
    } else {
      AnalyticsService.error('updateList', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onRemoveList(ShoppingListTabRemoveList event,
      Emitter<ShoppingListTabState> emit) async {
    emit(const ShoppingListTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final result = await service.deleteList(event.listId);

    if (result.isSuccess()) {
      await listCacheService.removeListFromCache(event.listId);
      await listItemCacheService
          .removeAllListItemsFromCacheForList(event.listId);
      event.success(event.listId);
    } else {
      AnalyticsService.error('removeList', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onQuitFromList(ShoppingListTabQuitFromList event,
      Emitter<ShoppingListTabState> emit) async {
    emit(const ShoppingListTabLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.error(Lang.notConnected);
      return;
    }

    final userId = authenticationService.userId;
    final result = await userService.quitFromList(event.listId, userId);

    if (result.isSuccess()) {
      await listCacheService.removeListFromCache(event.listId);
      await listItemCacheService
          .removeAllListItemsFromCacheForList(event.listId);
      event.success(event.listId);
    } else {
      AnalyticsService.error('quitFromList', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }
}
