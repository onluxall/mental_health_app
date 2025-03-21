part of 'auth_bloc.dart';

abstract class AuthEvent extends BaseEvent {
  AuthEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class AuthEventInit extends AuthEvent {}

class AuthEventChangeScreen extends AuthEvent {
  final int screenIndex;

  AuthEventChangeScreen({required this.screenIndex}) : super(isLoading: true);
}

class AuthEventChangeName extends AuthEvent {
  final String name;

  AuthEventChangeName({required this.name}) : super(isLoading: true);
}

class AuthEventChangeEmail extends AuthEvent {
  final String email;

  AuthEventChangeEmail({required this.email}) : super(isLoading: true);
}

class AuthEventChangePassword extends AuthEvent {
  final String password;

  AuthEventChangePassword({required this.password}) : super(isLoading: true);
}

class AuthEventLogIn extends AuthEvent {}

class AuthEventSignUp extends AuthEvent {}
