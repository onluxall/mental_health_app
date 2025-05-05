import 'data.dart';

abstract class IJournalRepo {
  Future addJournalEntry({required JournalEntry entry});
  Future<List<JournalEntry>> getJournalEntriesByUser({required String userId});
  Future updateJournalEntry({required String id, required String title, required String content});
  Stream<List<JournalEntry>> observeJournalEntriesByUser({required String userId});
  Stream<JournalEntry?> observeJournalEntryByDate({required String userId, required DateTime date});
}
