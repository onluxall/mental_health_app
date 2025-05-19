part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  HomeEvent({super.isLoading, super.error});
}

class HomeEventInit extends HomeEvent {}

class HomeEventChangeMood extends HomeEvent {
  final double mood;
  HomeEventChangeMood({required this.mood});
}

class HomeEventAddActivity extends HomeEvent {
  final Activity activity;
  HomeEventAddActivity({required this.activity});
}
