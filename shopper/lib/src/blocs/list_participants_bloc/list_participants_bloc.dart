import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/models/shopping_list_user_model.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/data/shopping_list_user_service.dart';

part 'list_participants_event.dart';
part 'list_participants_state.dart';

class ListParticipantsBloc
    extends Bloc<ListParticipantsEvent, ListParticipantsState> {
  final ShoppingListUserService service;

  ListParticipantsBloc({
    required this.service,
  }) : super(const ListParticipantsLoading()) {
    on<ListParticipantsEvent>((event, emit) async {
      switch (event) {
        case ListParticipantsLoadUsers():
          await _onLoadUsers(event, emit);
        case ListParticipantsAddUser():
          await _onAddUser(event, emit);
        case ListParticipantsRemoveUser():
          await _onRemoveUser(event, emit);
      }
    });
  }

  void initializeRealtimeListeners({
    required String listId,
    required Function(Map<String, dynamic> payloadMap) onInsert,
    required Function(Map<String, dynamic> payloadMap) onDelete,
  }) {
    service.initializeRealtimeListeners(
      listId: listId,
      onInsert: onInsert,
      onDelete: onDelete,
    );
  }

  @override
  Future<void> close() async {
    await service.removeRealtimeListeners();
    super.close();
  }

  Future<void> _onLoadUsers(ListParticipantsLoadUsers event,
      Emitter<ListParticipantsState> emit) async {
    emit(const ListParticipantsLoading());

    final result = await service.loadUsersForList(event.listId);

    if (result.isSuccess()) {
      emit(ListParticipantsLoaded(result.tryGetSuccess()!));
    } else {
      AnalyticsService.error('loadUsersOnline', {
        'message': result.tryGetError()!.message,
      });
      emit(ListParticipantsError(result.tryGetError()!.message));
    }
  }

  Future<void> _onAddUser(ListParticipantsAddUser event,
      Emitter<ListParticipantsState> emit) async {
    emit(const ListParticipantsLoading());

    final result =
        await service.addUserToList(event.userNickname, event.listId);

    if (result.isSuccess()) {
      event.success(result.tryGetSuccess()!);
    } else {
      AnalyticsService.error('addUser', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }

  Future<void> _onRemoveUser(ListParticipantsRemoveUser event,
      Emitter<ListParticipantsState> emit) async {
    emit(const ListParticipantsLoading());

    final result = await service.removeUserFromList(event.userRecordId);

    if (result.isSuccess()) {
      event.success(event.userRecordId);
    } else {
      AnalyticsService.error('removeUser', {
        'message': result.tryGetError()!.message,
      });
      event.error(result.tryGetError()!.message);
    }
  }
}
