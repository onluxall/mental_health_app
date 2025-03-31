import 'data.dart';

abstract class IJournalRepo {
  Future addJournalEntry({required JournalEntry entry});
  Future updateJournalEntry({required String id, required String title, required String content});
  Future<List<JournalEntry>> getJournalEntriesByUser({required String userId});
  Stream<JournalEntry?> observeJournalEntryByDate({required String userId, required DateTime date});
}
