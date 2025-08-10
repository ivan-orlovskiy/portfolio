part of 'list_participants_bloc.dart';

sealed class ListParticipantsState extends Equatable {
  const ListParticipantsState();

  @override
  List<Object> get props => [];
}

final class ListParticipantsLoading extends ListParticipantsState {
  const ListParticipantsLoading();
}

final class ListParticipantsLoaded extends ListParticipantsState {
  final List<ShoppingListUserModel> users;

  const ListParticipantsLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class ListParticipantsError extends ListParticipantsState {
  final String message;

  const ListParticipantsError(this.message);

  @override
  List<Object> get props => [message];
}
