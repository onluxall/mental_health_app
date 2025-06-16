import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/ui/base/base_event.dart';

import '../../../data/task/data.dart';
import '../../../use_case/task_init/task_init_use_case.dart';
import '../../../use_case/task_update/task_update_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

@Injectable()
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this._taskInitUseCase, this._taskUpdateUseCase) : super(const TaskState()) {
    on<TaskEventInit>(_onTaskEventInit);
    on<TaskEventUpdate>(_onTaskEventUpdate);
  }

  final ITaskInitUseCase _taskInitUseCase;
  final ITaskUpdateUseCase _taskUpdateUseCase;

  Future<void> _onTaskEventInit(
    TaskEventInit event,
    Emitter<TaskState> emit,
  ) async {
    await emit.forEach(
      _taskInitUseCase.invoke(),
      onData: (data) {
        print(data.error.toString());
        return state.copyWith(
          tasks: data.tasks,
          isLoading: data.isLoading,
          error: data.error.toString(),
        );
      },
    );
  }

  Future _onTaskEventUpdate(
    TaskEventUpdate event,
    Emitter<TaskState> emit,
  ) async {
    await _taskUpdateUseCase.invoke(taskId: event.taskId ?? "", isCompleted: event.isCompleted);
  }

  TaskState getState() {
    return state;
  }
}
