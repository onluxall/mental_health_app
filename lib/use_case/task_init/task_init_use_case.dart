import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';
import 'package:mental_health_app/use_case/task_init/task_init_response.dart';

import '../../data/task/interface.dart';

abstract class ITaskInitUseCase {
  Stream<TaskInitResponse> invoke();
}

@Injectable(as: ITaskInitUseCase)
class TaskInitUseCase implements ITaskInitUseCase {
  TaskInitUseCase({required this.taskRepo});
  final ITaskRepo taskRepo;

  @override
  Stream<TaskInitResponse> invoke() async* {
    yield TaskInitResponse(isLoading: true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
      final stream = taskRepo.getAllUserTasksForDate(date: DateTime.now().atStartOfDay(), userId: userId);
      await for (final tasks in stream) {
        print("Tasks: $tasks");
        yield TaskInitResponse(tasks: tasks, isLoading: false);
      }
    } catch (e) {
      yield TaskInitResponse(error: e);
    }
  }
}
