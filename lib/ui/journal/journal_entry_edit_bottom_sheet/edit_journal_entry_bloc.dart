import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../use_case/edit_journal_entry/edit_journal_entry_use_case.dart';
import '../../base/base_event.dart';

part 'edit_journal_entry_event.dart';
part 'edit_journal_entry_state.dart';

@Injectable()
class EditJournalEntryBloc extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  EditJournalEntryBloc(this._updateJournalEntryUseCase) : super(EditJournalEntryState()) {
    on<EditJournalEntryEventInit>(_onInit);
    on<EditJournalEntryEventUpdateTitle>(_onUpdateTitle);
    on<EditJournalEntryEventUpdateContent>(_onUpdateContent);
    on<EditJournalEntryEventSaveEntry>(_onSaveEntry);
  }

  final IUpdateJournalEntryUseCase _updateJournalEntryUseCase;

  void _onInit(EditJournalEntryEventInit event, Emitter<EditJournalEntryState> emit) {
    emit(state.copyWith(title: event.title, content: event.content));
  }

  void _onUpdateTitle(EditJournalEntryEventUpdateTitle event, Emitter<EditJournalEntryState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateContent(EditJournalEntryEventUpdateContent event, Emitter<EditJournalEntryState> emit) {
    emit(state.copyWith(content: event.content));
  }

  void _onSaveEntry(EditJournalEntryEventSaveEntry event, Emitter<EditJournalEntryState> emit) async {
    await emit.forEach(
      _updateJournalEntryUseCase.invoke(id: event.id, title: state.title, content: state.content),
      onData: (response) {
        if (response.isLoading) {
          return state.copyWith(isLoading: true);
        } else if (response.error != null) {
          return state.copyWith(isLoading: false, error: response.error);
        } else {
          return state.copyWith(isLoading: false, navigateBack: true);
        }
      },
      onError: (error, stackTrace) {
        return state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }
}
