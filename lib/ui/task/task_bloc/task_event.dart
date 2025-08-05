part of 'task_bloc.dart';

abstract class TaskEvent extends BaseEvent {
  TaskEvent({super.isLoading, super.error});
}

class TaskEventInit extends TaskEvent {
  TaskEventInit({super.isLoading, super.error});
}

class TaskEventUpdate extends TaskEvent {
  final bool isCompleted;
  final String? taskId;
  TaskEventUpdate({required this.isCompleted, required this.taskId, super.isLoading, super.error});
}
