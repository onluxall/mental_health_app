import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/journal/data.dart';
import 'package:mental_health_app/data/journal/interface.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';

import '../../get_it_conf.dart';

@Injectable(as: IJournalRepo)
class JournalRepo extends IJournalRepo {
  final journalEntryCollection = getIt<FirebaseFirestore>().collection('journalEntry');

  @override
  Future<void> addJournalEntry({required JournalEntry entry}) async {
    try {
      final ref = await journalEntryCollection.add(entry.toJson());
      ref.update({
        'id': ref.id,
      });
    } catch (e) {
      print('Error adding journal entry: $e');
    }
  }

  @override
  Future<List<JournalEntry>> getJournalEntriesByUser({required String userId}) async {
    try {
      QuerySnapshot snapshot = await journalEntryCollection.where('userId', isEqualTo: userId).get();
      List<JournalEntry> journalEntries = snapshot.docs.map((doc) => doc.data() as JournalEntry).toList();
      return journalEntries;
    } catch (e) {
      print('Error fetching journal entries: $e');
      return [];
    }
  }

  @override
  Stream<List<JournalEntry>> observeJournalEntriesByUser({required String userId}) {
    try {
      return journalEntryCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
      });
    } catch (e) {
      print('Error observing journal entries: $e');
      return Stream.value([]);
    }
  }

  @override
  Stream<JournalEntry?> observeJournalEntryByDate({required String userId, required DateTime date}) {
    DateTime midnight = date.atStartOfDay();
    try {
      return journalEntryCollection
          .where('userId', isEqualTo: userId)
          .where("date", isEqualTo: Timestamp.fromMillisecondsSinceEpoch(midnight.millisecondsSinceEpoch))
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return JournalEntry.fromJson(snapshot.docs.first.data());
        } else {
          return null;
        }
      });
    } catch (e) {
      print('Error observing journal entry: $e');
    }
    return Stream.value(null);
  }

  @override
  Future<void> updateJournalEntry({required String id, required String title, required String content}) async {
    try {
      await journalEntryCollection.doc(id).update({
        'title': title,
        'content': content,
      });
    } catch (e) {
      print('Error updating journal entry: $e');
    }
  }
}
