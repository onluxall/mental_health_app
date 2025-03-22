import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/ui/base/base_event.dart';
import 'package:mental_health_app/use_case/auth_init/auth_init_use_case.dart';
import 'package:mental_health_app/use_case/log_in/log_in_use_case.dart';
import 'package:mental_health_app/use_case/sign_up/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._signUpUC, this._logInUC, this._authInitUC) : super(const AuthState()) {
    on<AuthEventInit>(_onAuthEventInit);
    on<AuthEventChangeScreen>(_onAuthEventChangeScreen);
    on<AuthEventChangeName>(_onAuthEventChangeName);
    on<AuthEventChangeEmail>(_onAuthEventChangeEmail);
    on<AuthEventChangePassword>(_onAuthEventChangePassword);
    on<AuthEventSignUp>(_onAuthEventSignUp);
    on<AuthEventLogIn>(_onAuthEventLogIn);
  }

  final ISignUpUseCase _signUpUC;
  final ILogInUseCase _logInUC;
  final IAuthInitUseCase _authInitUC;

  int? chosenScreen;
  String? name;
  String? email;
  String? password;
  bool isLoading = false;
  bool isLoggedIn = false;
  dynamic error;

  void _onAuthEventInit(AuthEventInit event, Emitter<AuthState> emit) async {
    chosenScreen = 0;
    await for (final result in _authInitUC.invoke()) {
      if (result.isSuccessful()) {
        isLoggedIn = result.isLoggedIn ?? false;
        return emit(getCurrentState());
      } else if (result.error != null) {
        return emit(getCurrentState());
      }
    }
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
    await for (final result in _signUpUC.invoke(email: email ?? "", password: password ?? "")) {
      if (result.isSuccessful()) {
        chosenScreen = 1;
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
    await for (final result in _logInUC.invoke(email: email ?? "", password: password ?? "")) {
      if (result.isSuccessful()) {
        isLoggedIn = true;
        return emit(getCurrentState());
      } else if (result.error != null) {
        return emit(getCurrentState());
      }
    }
  }

  AuthState getCurrentState() {
    return AuthState(
      chosenScreen: chosenScreen ?? 0,
      isLoggedIn: isLoggedIn,
      name: name,
      email: email,
      password: password,
      isLoading: state.isLoading,
      error: state.error,
    );
  }
}
