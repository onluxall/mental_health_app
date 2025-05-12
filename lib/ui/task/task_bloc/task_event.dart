part of 'task_bloc.dart';

abstract class TaskEvent extends BaseEvent {
  TaskEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class TaskEventInit extends TaskEvent {
  TaskEventInit({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class TaskEventUpdate extends TaskEvent {
  final bool isCompleted;
  final String? taskId;
  TaskEventUpdate({required this.isCompleted, required this.taskId, bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}
