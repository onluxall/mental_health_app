import 'data.dart';

abstract class ITaskRepo {
  Stream<List<UserTask>> getAllUserTasksForDate({required DateTime date, required String userId});
  Future<void> updateUserTask({required String taskId, required bool isCompleted});
}
