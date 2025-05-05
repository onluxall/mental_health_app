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

import 'data/journal/interface.dart' as _i485;
import 'data/journal/repo.dart' as _i268;
import 'data/user/interface.dart' as _i494;
import 'data/user/repo.dart' as _i526;
import 'ui/auth/auth_bloc/auth_bloc.dart' as _i123;
import 'ui/home/daily_note/daily_note_bloc.dart' as _i252;
import 'ui/home/home_bloc.dart' as _i470;
import 'ui/journal/journal_bloc/journal_bloc.dart' as _i635;
import 'ui/journal/journal_entry_edit_bottom_sheet/edit_journal_entry_bloc.dart'
    as _i525;
import 'ui/main_navigator/main_navigator_cubit.dart' as _i133;
import 'use_case/add_journal_entry/add_journal_entry_use_case.dart' as _i811;
import 'use_case/auth_init/auth_init_use_case.dart' as _i528;
import 'use_case/edit_journal_entry/edit_journal_entry_use_case.dart' as _i267;
import 'use_case/home_init/home_init_use_case.dart' as _i631;
import 'use_case/journal_init/journal_init_use_case.dart' as _i424;
import 'use_case/log_in/log_in_use_case.dart' as _i646;
import 'use_case/sign_up/sign_up_use_case.dart' as _i294;

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
  gh.factory<_i811.IAddJournalEntryUseCase>(() => _i811.AddJournalEntryUseCase(
        gh<_i485.IJournalRepo>(),
        gh<_i59.FirebaseAuth>(),
      ));
  gh.factory<_i294.ISignUpUseCase>(
      () => _i294.SignUpUseCase(gh<_i494.IUserRepo>()));
  gh.factory<_i267.IUpdateJournalEntryUseCase>(
      () => _i267.UpdateJournalEntryUseCase(gh<_i485.IJournalRepo>()));
  gh.factory<_i252.DailyNoteBloc>(() => _i252.DailyNoteBloc(
        gh<_i811.IAddJournalEntryUseCase>(),
        gh<_i267.IUpdateJournalEntryUseCase>(),
      ));
  gh.factory<_i133.MainNavigatorCubit>(() => _i133.MainNavigatorCubit(
        gh<_i494.IUserRepo>(),
        gh<_i59.FirebaseAuth>(),
      ));
  gh.factory<_i631.IHomeInitUseCase>(() => _i631.HomeInitUseCase(
        gh<_i494.IUserRepo>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i485.IJournalRepo>(),
      ));
  gh.factory<_i123.AuthBloc>(() => _i123.AuthBloc(
        gh<_i294.ISignUpUseCase>(),
        gh<_i646.ILogInUseCase>(),
        gh<_i528.IAuthInitUseCase>(),
      ));
  gh.factory<_i424.IJournalInitUseCase>(() => _i424.JournalInitUseCase(
        gh<_i59.FirebaseAuth>(),
        gh<_i485.IJournalRepo>(),
      ));
  gh.factory<_i525.EditJournalEntryBloc>(
      () => _i525.EditJournalEntryBloc(gh<_i267.IUpdateJournalEntryUseCase>()));
  gh.factory<_i470.HomeBloc>(
      () => _i470.HomeBloc(gh<_i631.IHomeInitUseCase>()));
  gh.factory<_i635.JournalBloc>(
      () => _i635.JournalBloc(gh<_i424.IJournalInitUseCase>()));
  return getIt;
}
