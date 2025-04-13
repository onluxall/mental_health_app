part of 'task_bloc.dart';

abstract class TaskEvent extends BaseEvent {
  TaskEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

// class ToggleTaskAcceptanceEvent extends TaskEvent {
//   final String taskId;
//
//   ToggleTaskAcceptanceEvent(
//     this.taskId,
//   );
// }
