import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/activity/interface.dart';
import 'package:mental_health_app/data/journal/interface.dart';
import 'package:mental_health_app/data/task/interface.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/activity/data.dart';
import '../../data/journal/data.dart';
import '../../data/task/data.dart';
import 'journal_init_response.dart';

abstract class IJournalInitUseCase {
  Stream<JournalInitResponse> invoke();
}

@Injectable(as: IJournalInitUseCase)
class JournalInitUseCase extends IJournalInitUseCase {
  JournalInitUseCase(this._auth, this._journalRepo, this._taskRepo, this._activityRepo);
  final FirebaseAuth _auth;
  final IJournalRepo _journalRepo;
  final ITaskRepo _taskRepo;
  final IActivityRepo _activityRepo;

  @override
  Stream<JournalInitResponse> invoke() async* {
    try {
      yield JournalInitResponse(isLoading: true);
      final userId = _auth.currentUser?.uid;
      final combinedStream = CombineLatestStream.combine3(
          _journalRepo.observeJournalEntriesByUser(userId: userId ?? ""),
          _taskRepo.observeAllUserTasks(userId: userId ?? ""),
          _activityRepo.getActivitiesByUser(userId: userId ?? ""), (List<JournalEntry> journalEntries, List<UserTask> userTasks, List<Activity> activities) {
        return JournalInitResponse(
          journalEntries: journalEntries,
          userTasks: userTasks,
          activities: activities,
          isLoading: false,
        );
      });
      await for (var event in combinedStream) {
        yield event;
      }
    } catch (e) {
      yield JournalInitResponse(error: e.toString());
    }
  }
}
