part of 'list_participants_bloc.dart';

sealed class ListParticipantsEvent extends Equatable {
  const ListParticipantsEvent();

  @override
  List<Object> get props => [];
}

final class ListParticipantsLoadUsers extends ListParticipantsEvent {
  final String listId;

  const ListParticipantsLoadUsers(this.listId);

  @override
  List<Object> get props => [listId];
}

final class ListParticipantsAddUser extends ListParticipantsEvent {
  final String userNickname;
  final String listId;
  final Function(ShoppingListUserModel newRecord) success;
  final Function(String errorMessage) error;

  const ListParticipantsAddUser(this.userNickname, this.listId, this.success, this.error);

  @override
  List<Object> get props => [userNickname, listId, success, error];
}

final class ListParticipantsRemoveUser extends ListParticipantsEvent {
  final String userRecordId;
  final Function(String userRecordId) success;
  final Function(String errorMessage) error;

  const ListParticipantsRemoveUser(this.userRecordId, this.success, this.error);

  @override
  List<Object> get props => [userRecordId, success, error];
}
