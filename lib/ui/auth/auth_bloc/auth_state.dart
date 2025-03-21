part of "auth_bloc.dart";

class AuthState extends Equatable {
  const AuthState({
    this.chosenScreen = 0,
    this.name,
    this.email,
    this.password,
    this.isLoading = false,
    this.error,
  });

  final int chosenScreen;
  final String? name;
  final String? email;
  final String? password;
  final bool isLoading;
  final dynamic error;

  @override
  List<Object?> get props => [
        chosenScreen,
        name,
        email,
        password,
        isLoading,
        error,
      ];
}
