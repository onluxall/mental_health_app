part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  HomeEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class HomeEventInit extends HomeEvent {}

class HomeEventChangeMood extends HomeEvent {
  final double mood;
  HomeEventChangeMood({required this.mood});
}
