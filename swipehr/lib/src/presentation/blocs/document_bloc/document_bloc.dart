import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final SupabaseClient database;

  DocumentBloc({
    required this.database,
  }) : super(const DocumentLoading()) {
    on<LoadDocument>((event, emit) => _onLoad(event, emit));
  }

  void _onLoad(LoadDocument event, Emitter<DocumentState> emit) async {
    emit(const DocumentLoading());
    try {
      final Uint8List file = await database.storage.from('files').download(event.path);
      emit(DocumentLoaded(file));
    } catch (_) {
      emit(const DocumentLoaded(null));
    }
  }
}
