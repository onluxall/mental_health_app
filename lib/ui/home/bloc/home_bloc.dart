import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/data.dart';
import 'package:mental_health_app/use_case/add_activity/add_activity_use_case.dart';

import '../../../data/activity/data.dart';
import '../../../data/api_models/quote.dart';
import '../../../data/journal/data.dart';
import '../../../use_case/home_init/home_init_use_case.dart';
import '../../base/base_event.dart';

part 'home_event.dart';
part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dailyQuoteUC, this._addActivityUC) : super(const HomeState()) {
    on<HomeEventInit>(_onHomeEventInit);
    on<HomeEventChangeMood>(_onHomeEventChangeMood);
    on<HomeEventAddActivity>(_onHomeEventAddActivity);
  }

  final IHomeInitUseCase _dailyQuoteUC;
  final IAddActivityUseCase _addActivityUC;

  bool isLoading = false;
  dynamic error;
  Quote? quote;
  UserData? user;
  JournalEntry? todayJournalEntry;
  double? mood;

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

  void _onHomeEventAddActivity(HomeEventAddActivity event, Emitter<HomeState> emit) async {
    await emit.forEach(
      _addActivityUC.invoke(activity: event.activity),
      onData: (result) {
        if (result.isSuccessful()) {
          // Handle successful activity addition
        }
        error = result.error;
        isLoading = result.isLoading;
        return getCurrentState();
      },
    );
  }

  _onHomeEventChangeMood(HomeEventChangeMood event, Emitter<HomeState> emit) {
    mood = event.mood;
    emit(getCurrentState());
  }

  HomeState getCurrentState() {
    return HomeState(
      quote: quote,
      user: user,
      todayJournalEntry: todayJournalEntry,
      mood: mood,
      isLoading: isLoading,
      error: error,
    );
  }
}
