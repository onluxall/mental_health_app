// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/activity/interface.dart' as _i805;
import 'data/activity/repo.dart' as _i999;
import 'data/emotion/interface.dart' as _i756;
import 'data/emotion/repo.dart' as _i634;
import 'data/journal/interface.dart' as _i485;
import 'data/journal/repo.dart' as _i268;
import 'data/task/interface.dart' as _i0;
import 'data/task/repo.dart' as _i207;
import 'data/user/interface.dart' as _i494;
import 'data/user/repo.dart' as _i526;
import 'ui/auth/auth_bloc/auth_bloc.dart' as _i123;
import 'ui/home/bloc/home_bloc.dart' as _i56;
import 'ui/home/daily_note/daily_note_bloc.dart' as _i252;
import 'ui/home/emotions_slider/emotions_slider_bloc.dart' as _i668;
import 'ui/journal/journal_bloc/journal_bloc.dart' as _i635;
import 'ui/journal/journal_entry_edit_bottom_sheet/edit_journal_entry_bloc.dart'
    as _i525;
import 'ui/main_navigator/main_navigator_cubit.dart' as _i133;
import 'ui/task/task_bloc/task_bloc.dart' as _i488;
import 'use_case/add_activity/add_activity_use_case.dart' as _i914;
import 'use_case/add_emotion/add_emotion_use_case.dart' as _i772;
import 'use_case/add_journal_entry/add_journal_entry_use_case.dart' as _i811;
import 'use_case/auth_init/auth_init_use_case.dart' as _i528;
import 'use_case/edit_journal_entry/edit_journal_entry_use_case.dart' as _i267;
import 'use_case/home_init/home_init_use_case.dart' as _i631;
import 'use_case/journal_init/journal_init_use_case.dart' as _i424;
import 'use_case/log_in/log_in_use_case.dart' as _i646;
import 'use_case/observe_emotions/observe_emotions_use_case.dart' as _i699;
import 'use_case/sign_up/sign_up_use_case.dart' as _i294;
import 'use_case/task_init/task_init_use_case.dart' as _i503;
import 'use_case/task_update/task_update_use_case.dart' as _i878;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i646.ILogInUseCase>(() => _i646.LogInUseCase());
  gh.factory<_i494.IUserRepo>(() => _i526.UserRepo());
  gh.factory<_i528.IAuthInitUseCase>(
      () => _i528.AuthInitUseCase(gh<_i59.FirebaseAuth>()));
  gh.factory<_i485.IJournalRepo>(() => _i268.JournalRepo());
  gh.factory<_i0.ITaskRepo>(() => _i207.TaskRepo());
  gh.factory<_i811.IAddJournalEntryUseCase>(() => _i811.AddJournalEntryUseCase(
        gh<_i485.IJournalRepo>(),
        gh<_i59.FirebaseAuth>(),
      ));
  gh.factory<_i294.ISignUpUseCase>(
      () => _i294.SignUpUseCase(gh<_i494.IUserRepo>()));
  gh.factory<_i805.IActivityRepo>(() => _i999.ActivityRepo());
  gh.factory<_i756.IEmotionRepo>(() => _i634.EmotionRepo());
  gh.factory<_i631.IHomeInitUseCase>(() => _i631.HomeInitUseCase(
        gh<_i494.IUserRepo>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i485.IJournalRepo>(),
        gh<_i756.IEmotionRepo>(),
      ));
  gh.factory<_i267.IUpdateJournalEntryUseCase>(
      () => _i267.UpdateJournalEntryUseCase(gh<_i485.IJournalRepo>()));
  gh.factory<_i252.DailyNoteBloc>(() => _i252.DailyNoteBloc(
        gh<_i811.IAddJournalEntryUseCase>(),
        gh<_i267.IUpdateJournalEntryUseCase>(),
      ));
  gh.factory<_i503.ITaskInitUseCase>(
      () => _i503.TaskInitUseCase(taskRepo: gh<_i0.ITaskRepo>()));
  gh.factory<_i424.IJournalInitUseCase>(() => _i424.JournalInitUseCase(
        gh<_i59.FirebaseAuth>(),
        gh<_i485.IJournalRepo>(),
        gh<_i0.ITaskRepo>(),
        gh<_i805.IActivityRepo>(),
      ));
  gh.factory<_i133.MainNavigatorCubit>(() => _i133.MainNavigatorCubit(
        gh<_i494.IUserRepo>(),
        gh<_i59.FirebaseAuth>(),
      ));
  gh.factory<_i878.ITaskUpdateUseCase>(
      () => _i878.TaskUpdateUseCase(gh<_i0.ITaskRepo>()));
  gh.factory<_i635.JournalBloc>(
      () => _i635.JournalBloc(gh<_i424.IJournalInitUseCase>()));
  gh.factory<_i914.IAddActivityUseCase>(
      () => _i914.AddActivityUseCase(gh<_i805.IActivityRepo>()));
  gh.factory<_i123.AuthBloc>(() => _i123.AuthBloc(
        gh<_i294.ISignUpUseCase>(),
        gh<_i646.ILogInUseCase>(),
        gh<_i528.IAuthInitUseCase>(),
      ));
  gh.factory<_i772.IAddEmotionUseCase>(
      () => _i772.AddEmotionUseCase(gh<_i756.IEmotionRepo>()));
  gh.factory<_i699.IObserveEmotionsUseCase>(
      () => _i699.ObserveEmotionsUseCase(gh<_i756.IEmotionRepo>()));
  gh.factory<_i668.EmotionsSliderBloc>(
      () => _i668.EmotionsSliderBloc(gh<_i772.IAddEmotionUseCase>()));
  gh.factory<_i525.EditJournalEntryBloc>(
      () => _i525.EditJournalEntryBloc(gh<_i267.IUpdateJournalEntryUseCase>()));
  gh.factory<_i56.HomeBloc>(() => _i56.HomeBloc(
        gh<_i631.IHomeInitUseCase>(),
        gh<_i914.IAddActivityUseCase>(),
      ));
  gh.factory<_i488.TaskBloc>(() => _i488.TaskBloc(
        gh<_i503.ITaskInitUseCase>(),
        gh<_i878.ITaskUpdateUseCase>(),
      ));
  return getIt;
}
