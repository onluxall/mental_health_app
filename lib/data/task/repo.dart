import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'data.dart';
import 'interface.dart';

@Injectable(as: ITaskRepo)
class TaskRepo implements ITaskRepo {
  final taskCollection = FirebaseFirestore.instance.collection('task');

  @override
  Stream<List<UserTask>> observeAllUserTasksForDate({required DateTime date, required String userId}) async* {
    yield* taskCollection
        .where('userId', isEqualTo: userId)
        // .where('date', isEqualTo: date) // Uncomment this line if you want to filter by date But sth needs to be changed here to fetch it correctly
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => UserTask.fromJson(doc.data())).toList(),
        );
  }

  @override
  Stream<List<UserTask>> observeAllUserTasks({required String userId}) async* {
    try {
      yield* taskCollection.where('userId', isEqualTo: userId).snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => UserTask.fromJson(doc.data())).toList(),
          );
    } catch (e) {
      print('Error observing all user tasks: $e');
      yield [];
    }
  }

  @override
  Future updateUserTask({required String taskId, required bool isCompleted}) async {
    await taskCollection.doc(taskId).update({'isCompleted': isCompleted});
  }
}
