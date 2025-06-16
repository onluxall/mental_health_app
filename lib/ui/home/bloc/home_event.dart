part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  HomeEvent({super.isLoading, super.error});
}

class HomeEventInit extends HomeEvent {}

class HomeEventAddActivity extends HomeEvent {
  final Activity activity;
  HomeEventAddActivity({required this.activity});
}
