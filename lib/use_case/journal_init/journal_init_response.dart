import '../../data/journal/data.dart';
import '../base_use_case_response.dart';

class JournalInitResponse extends BaseUseCaseResponse {
  JournalInitResponse({this.journalEntries, bool isLoading = false, dynamic error}) : super(isLoading: isLoading, error: error);

  final List<JournalEntry>? journalEntries;
}
