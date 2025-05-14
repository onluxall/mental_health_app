import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/task/data.dart';

import '../../../data/journal/data.dart';
import '../../../use_case/journal_init/journal_init_response.dart';
import '../../../use_case/journal_init/journal_init_use_case.dart';
import '../../base/base_event.dart';

part 'journal_event.dart';
part 'journal_state.dart';

@Injectable()
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc(this._journalInitUseCase) : super(const JournalState()) {
    on<JournalEventInit>(_onJournalEventInit);
    on<JournalEventChangeDate>(_onJournalEventChangeDate);
  }

  final IJournalInitUseCase _journalInitUseCase;

  Future<void> _onJournalEventInit(
    JournalEventInit event,
    Emitter<JournalState> emit,
  ) async {
    await emit.forEach(_journalInitUseCase.invoke(), onData: (JournalInitResponse response) {
      if (response.isLoading) {
        return state.copyWith(isLoading: true);
      } else if (response.error != null) {
        return state.copyWith(isLoading: false, error: response.error);
      } else {
        return state.copyWith(
          isLoading: false,
          userJournalEntries: response.journalEntries,
          userTasks: response.userTasks,
          chosenDate: state.chosenDate ?? DateTime.now(),
        );
      }
    }, onError: (error, stackTrace) {
      return state.copyWith(isLoading: false, error: error);
    });
  }

  void _onJournalEventChangeDate(
    JournalEventChangeDate event,
    Emitter<JournalState> emit,
  ) {
    emit(state.copyWith(chosenDate: event.chosenDate));
  }
}
