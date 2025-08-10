import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/models/shopping_list_item_model.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/cache/shopping_list_item_cache_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/services/data/shopping_list_item_service.dart';

part 'shopping_list_page_event.dart';
part 'shopping_list_page_state.dart';

class ShoppingListPageBloc
    extends Bloc<ShoppingListPageEvent, ShoppingListPageState> {
  final ConnectionService connectionService;
  final ShoppingListItemService service;
  final ShoppingListItemCacheService cacheService;

  ShoppingListPageBloc({
    required this.connectionService,
    required this.service,
    required this.cacheService,
  }) : super(const ShoppingListPageLoading()) {
    on<ShoppingListPageEvent>((event, emit) async {
      switch (event) {
        case ShoppingListPageLoadItems():
          await _onLoadItems(event, emit);
        case ShoppingListPageAddItem():
          await _onAddItem(event, emit);
        case ShoppingListPageRemoveItem():
          await _onRemoveItem(event, emit);
        case ShoppingListPageRemoveAllItems():
          await _onRemoveAllItems(event, emit);
        case ShoppingListPageMarkItem():
          await _onMarkItem(event, emit);
      }
    });
  }

  void initializeRealtimeListeners({
    required String filterListId,
    required Function(Map<String, dynamic> payloadMap) onInsert,
    required Function(Map<String, dynamic> payloadMap) onUpdate,
    required Function(Map<String, dynamic> payloadMap) onDelete,
  }) {
    service.initializeRealtimeListeners(
      filterListId: filterListId,
      onInsert: (payloadMap) async {
        onInsert(payloadMap);
        await cacheService
            .addListItemToCache(ShoppingListItemModel.fromMap(payloadMap));
      },
      onUpdate: (payloadMap) async {
        onUpdate(payloadMap);
        await cacheService.markListItemInCache(
          payloadMap['id'] as String,
          payloadMap['is_done'] as bool,
        );
      },
      onDelete: (payloadMap) async {
        onDelete(payloadMap);
        await cacheService.removeListItemFromCache(payloadMap['id']);
      },
    );
  }

  @override
  Future<void> close() async {
    await service.removeRealtimeListeners();
    super.close();
  }

  Future<void> _onLoadItems(ShoppingListPageLoadItems event,
      Emitter<ShoppingListPageState> emit) async {
    emit(const ShoppingListPageLoading());

    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      final result =
          await cacheService.loadListItemsFromCacheForList(event.listId);

      if (result.isSuccess()) {
        emit(ShoppingListPageLoaded(result.tryGetSuccess()!));
      } else {
        AnalyticsService.error('loadItemsCache', {
          'message': result.tryGetError()!.message,
        });
        emit(ShoppingListPageError(result.tryGetError()!.message));
      }

      return;
    }

    final result = await service.loadListItemsForList(event.listId);

    if (result.isSuccess()) {
      await cacheService.addAllItems(result.tryGetSuccess()!);
      emit(ShoppingListPageLoaded(result.tryGetSuccess()!));
    } else {
      AnalyticsService.error('loadItemsOnline', {
        'message': result.tryGetError()!.message,
      });
      emit(ShoppingListPageError(result.tryGetError()!.message));
    }
  }

  Future<void> _onAddItem(ShoppingListPageAddItem event,
      Emitter<ShoppingListPageState> emit) async {
    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.restore('Not connected to network');
      return;
    }

    final result = await service.createListItem(event.item);

    if (result.isSuccess()) {
      await cacheService.addListItemToCache(event.item);
    } else {
      AnalyticsService.error('addItem', {
        'message': result.tryGetError()!.message,
      });
      event.restore(result.tryGetError()!.message);
    }
  }

  Future<void> _onRemoveItem(ShoppingListPageRemoveItem event,
      Emitter<ShoppingListPageState> emit) async {
    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.restore('Not connected to network');
      return;
    }

    final result = await service.deleteListItem(event.itemId);

    if (result.isSuccess()) {
      await cacheService.removeListItemFromCache(event.itemId);
    } else {
      AnalyticsService.error('removeItem', {
        'message': result.tryGetError()!.message,
      });
      event.restore(result.tryGetError()!.message);
    }
  }

  Future<void> _onRemoveAllItems(ShoppingListPageRemoveAllItems event,
      Emitter<ShoppingListPageState> emit) async {
    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.restore('Not connected to network');
      return;
    }

    final result = await service.deleteAllListItems(event.listId);

    if (result.isSuccess()) {
      await cacheService.removeAllListItemsFromCacheForList(event.listId);
    } else {
      AnalyticsService.error('removeAllItems', {
        'message': result.tryGetError()!.message,
      });
      event.restore(result.tryGetError()!.message);
    }
  }

  Future<void> _onMarkItem(ShoppingListPageMarkItem event,
      Emitter<ShoppingListPageState> emit) async {
    final isConnected = await connectionService.isConnected;
    if (!isConnected) {
      event.restore('Not connected to network');
      return;
    }

    final result = await service.markListItem(event.itemId, event.newState);

    if (result.isSuccess()) {
      await cacheService.markListItemInCache(event.itemId, event.newState);
    } else {
      AnalyticsService.error('markItem', {
        'message': result.tryGetError()!.message,
      });
      event.restore(result.tryGetError()!.message);
    }
  }
}
