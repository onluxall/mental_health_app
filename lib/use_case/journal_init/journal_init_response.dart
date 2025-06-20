import '../../data/activity/data.dart';
import '../../data/journal/data.dart';
import '../../data/task/data.dart';
import '../base_use_case_response.dart';

class JournalInitResponse extends BaseUseCaseResponse {
  JournalInitResponse({this.journalEntries, this.userTasks, this.activities, super.isLoading, super.error});

  final List<JournalEntry>? journalEntries;
  final List<UserTask>? userTasks;
  final List<Activity>? activities;
}
