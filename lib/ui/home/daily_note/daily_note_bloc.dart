import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';
import 'package:mental_health_app/use_case/add_journal_entry/add_journal_entry_use_case.dart';

import '../../../use_case/edit_journal_entry/edit_journal_entry_use_case.dart';
import '../../base/base_event.dart';

part 'daily_note_event.dart';
part 'daily_note_state.dart';

@Injectable()
class DailyNoteBloc extends Bloc<DailyNoteEvent, DailyNoteState> {
  DailyNoteBloc(this._addJournalEntryUseCase, this._updateJournalEntryUseCase) : super(const DailyNoteState()) {
    on<DailyNoteEventInit>(_onInit);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<UpdateContentEvent>(_onUpdateContent);
    on<SubmitEvent>(_onSubmit);
    on<UpdateEvent>(_onUpdateEntry);
  }

  final IAddJournalEntryUseCase _addJournalEntryUseCase;
  final IUpdateJournalEntryUseCase _updateJournalEntryUseCase;

  void _onInit(DailyNoteEventInit event, Emitter<DailyNoteState> emit) async {
    if (event.id != null) {
      emit(state.copyWith(
        id: event.id,
        title: event.title,
        content: event.content,
      ));
    }
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<DailyNoteState> emit) {
    emit(state.copyWith(
      title: event.title,
      error: null,
    ));
  }

  void _onUpdateContent(UpdateContentEvent event, Emitter<DailyNoteState> emit) {
    emit(state.copyWith(
      content: event.content,
      error: null,
    ));
  }

  Future<void> _onSubmit(SubmitEvent event, Emitter<DailyNoteState> emit) async {
    if (state.title.isEmpty || state.content.isEmpty) {
      emit(state.copyWith(
        error: 'Please fill in all fields',
      ));
      return;
    }

    try {
      await emit.forEach(
        _addJournalEntryUseCase.invoke(
          title: state.title,
          content: state.content,
          date: DateTime.now().atStartOfDay(),
        ),
        onData: (response) {
          if (response.error != null) {
            return state.copyWith(
              isLoading: false,
              error: response.error.toString(),
            );
          }

          return state.copyWith(
            isLoading: response.isLoading,
            navigateBack: !response.isLoading,
            error: null,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to save: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateEntry(UpdateEvent event, Emitter<DailyNoteState> emit) async {
    await emit.forEach(
      _updateJournalEntryUseCase.invoke(
        id: state.id ?? '',
        title: state.title,
        content: state.content,
      ),
      onData: (response) {
        if (response.error != null) {
          return state.copyWith(
            isLoading: false,
            error: response.error.toString(),
          );
        }
        return state.copyWith(
          isLoading: response.isLoading,
          navigateBack: !response.isLoading,
          error: null,
        );
      },
    );
  }
}
