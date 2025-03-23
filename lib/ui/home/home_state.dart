part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Quote? quote;
  final UserData? user;
  final bool isLoading;
  final dynamic error;

  const HomeState({
    this.quote,
    this.user,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [quote, user, isLoading, error];
}
