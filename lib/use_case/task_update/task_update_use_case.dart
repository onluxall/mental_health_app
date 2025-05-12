import 'package:injectable/injectable.dart';

import '../../data/task/interface.dart';

abstract class ITaskUpdateUseCase {
  Future invoke({required String taskId, required bool isCompleted});
}

@Injectable(as: ITaskUpdateUseCase)
class TaskUpdateUseCase implements ITaskUpdateUseCase {
  TaskUpdateUseCase(this._taskRepo);

  final ITaskRepo _taskRepo;

  @override
  Future invoke({required String taskId, required bool isCompleted}) async {
    // TODO add error handling in the future
    await _taskRepo.updateUserTask(taskId: taskId, isCompleted: isCompleted);
  }
}
