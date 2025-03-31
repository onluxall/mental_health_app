import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/data.dart';

import '../../data/api_models/quote.dart';
import '../../data/journal/data.dart';
import '../../use_case/home_init/home_init_use_case.dart';
import '../base/base_event.dart';

part 'home_event.dart';
part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dailyQuoteUC) : super(const HomeState()) {
    on<HomeEventInit>(_onHomeEventInit);
  }

  final IHomeInitUseCase _dailyQuoteUC;

  bool isLoading = false;
  dynamic error;
  Quote? quote;
  UserData? user;
  JournalEntry? todayJournalEntry;

  Future<void> _onHomeEventInit(HomeEventInit event, Emitter<HomeState> emit) async {
    await emit.forEach(
      _dailyQuoteUC.invoke(),
      onData: (result) {
        if (result.isSuccessful()) {
          quote = result.quote;
          user = result.user;
          todayJournalEntry = result.todayJournalEntry;
        }
        error = result.error;
        isLoading = result.isLoading;
        return getCurrentState();
      },
    );
  }

  HomeState getCurrentState() {
    return HomeState(
      quote: quote,
      user: user,
      todayJournalEntry: todayJournalEntry,
      isLoading: isLoading,
      error: error,
    );
  }
}
