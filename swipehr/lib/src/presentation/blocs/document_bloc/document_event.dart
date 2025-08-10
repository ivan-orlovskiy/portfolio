part of 'document_bloc.dart';

sealed class DocumentEvent extends Equatable {
  const DocumentEvent();
}

class LoadDocument extends DocumentEvent {
  final String path;

  const LoadDocument(this.path);

  @override
  List<Object> get props => [path];
}
