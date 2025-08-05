import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/data.dart';
import 'package:mental_health_app/use_case/add_activity/add_activity_use_case.dart';

import '../../../data/activity/data.dart';
import '../../../data/api_models/quote.dart';
import '../../../data/emotion/data.dart';
import '../../../data/journal/data.dart';
import '../../../use_case/home_init/home_init_use_case.dart';
import '../../base/base_event.dart';

part 'home_event.dart';
part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._homeInitUC, this._addActivityUC) : super(const HomeState()) {
    on<HomeEventInit>(_onHomeEventInit);
    on<HomeEventAddActivity>(_onHomeEventAddActivity);
  }

  final IHomeInitUseCase _homeInitUC;
  final IAddActivityUseCase _addActivityUC;

  bool isLoading = false;
  dynamic error;
  Quote? quote;
  UserData? user;
  JournalEntry? todayJournalEntry;
  EmotionData? todayEmotionData;

  Future<void> _onHomeEventInit(HomeEventInit event, Emitter<HomeState> emit) async {
    await emit.forEach(
      _homeInitUC.invoke(),
      onData: (result) {
        if (result.isSuccessful()) {
          quote = result.quote;
          user = result.user;
          todayJournalEntry = result.todayJournalEntry;
          todayEmotionData = result.todayEmotionData;
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

  HomeState getCurrentState() {
    return HomeState(
      quote: quote,
      user: user,
      todayJournalEntry: todayJournalEntry,
      todayEmotionData: todayEmotionData,
      isLoading: isLoading,
      error: error,
    );
  }
}
