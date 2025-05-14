import '../../data/journal/data.dart';
import '../../data/task/data.dart';
import '../base_use_case_response.dart';

class JournalInitResponse extends BaseUseCaseResponse {
  JournalInitResponse({this.journalEntries, this.userTasks, bool isLoading = false, dynamic error}) : super(isLoading: isLoading, error: error);

  final List<JournalEntry>? journalEntries;
  final List<UserTask>? userTasks;
}
