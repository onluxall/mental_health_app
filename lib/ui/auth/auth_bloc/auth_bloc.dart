import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_app/ui/base/base_event.dart';
import 'package:mental_health_app/use_case/log_in/log_in_use_case.dart';
import 'package:mental_health_app/use_case/sign_up/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthEventInit>(_onAuthEventInit);
    on<AuthEventChangeScreen>(_onAuthEventChangeScreen);
    on<AuthEventChangeName>(_onAuthEventChangeName);
    on<AuthEventChangeEmail>(_onAuthEventChangeEmail);
    on<AuthEventChangePassword>(_onAuthEventChangePassword);
    on<AuthEventSignUp>(_onAuthEventSignUp);
    on<AuthEventLogIn>(_onAuthEventLogIn);
  }

  SignUpUseCase signUpUseCase = SignUpUseCase();
  LogInUseCase logInUseCase = LogInUseCase();

  int? chosenScreen;
  String? name;
  String? email;
  String? password;
  bool isLoading = false;
  dynamic error;

  void _onAuthEventInit(AuthEventInit event, Emitter<AuthState> emit) async {
    chosenScreen = 0;
    emit(getCurrentState());
  }

  void _onAuthEventChangeScreen(AuthEventChangeScreen event, Emitter<AuthState> emit) async {
    chosenScreen = event.screenIndex;
    emit(getCurrentState());
  }

  void _onAuthEventChangeName(AuthEventChangeName event, Emitter<AuthState> emit) async {
    name = event.name;
    emit(getCurrentState());
  }

  void _onAuthEventChangeEmail(AuthEventChangeEmail event, Emitter<AuthState> emit) async {
    email = event.email;
    emit(getCurrentState());
  }

  void _onAuthEventChangePassword(AuthEventChangePassword event, Emitter<AuthState> emit) async {
    password = event.password;
    emit(getCurrentState());
  }

  Future _onAuthEventSignUp(AuthEventSignUp event, Emitter<AuthState> emit) async {
    await for (final result in signUpUseCase.invoke(email: email ?? "", password: password ?? "")) {
      if (result.isSuccessful()) {
        return emit(getCurrentState());
      } else if (result.error != null) {
        return emit(getCurrentState());
      }
    }
  }

  Future _onAuthEventLogIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    if (email == null || password == null) {
      return;
    }
    await for (final result in logInUseCase.invoke(email: email ?? "", password: password ?? "")) {
      if (result.isSuccessful()) {
        return emit(getCurrentState());
      } else if (result.error != null) {
        return emit(getCurrentState());
      }
    }
  }

  AuthState getCurrentState() {
    return AuthState(
      chosenScreen: chosenScreen ?? 0,
      name: name,
      email: email,
      password: password,
      isLoading: state.isLoading,
      error: state.error,
    );
  }
}
