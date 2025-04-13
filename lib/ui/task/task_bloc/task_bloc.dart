import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_app/ui/base/base_event.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState()) {}
}
