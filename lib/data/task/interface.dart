import 'data.dart';

abstract class ITaskRepo {
  Stream<List<UserTask>> observeAllUserTasksForDate({required DateTime date, required String userId});
  Stream<List<UserTask>> observeAllUserTasks({required String userId});
  Future updateUserTask({required String taskId, required bool isCompleted});
}
