part of 'document_bloc.dart';

sealed class DocumentState extends Equatable {
  const DocumentState();
}

final class DocumentLoading extends DocumentState {
  const DocumentLoading();

  @override
  List<Object> get props => [];
}

final class DocumentLoaded extends DocumentState {
  final Uint8List? data;

  const DocumentLoaded(this.data);

  @override
  List<Object> get props => [];
}
