import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../data/journal/data.dart';
import '../../data/journal/interface.dart';
import '../base_use_case_response.dart';

abstract class IAddJournalEntryUseCase {
  Stream<BaseUseCaseResponse> invoke({required String title, required String content, required DateTime date});
}

@Injectable(as: IAddJournalEntryUseCase)
class AddJournalEntryUseCase extends IAddJournalEntryUseCase {
  AddJournalEntryUseCase(this._journalRepo, this._auth);
  final IJournalRepo _journalRepo;
  final FirebaseAuth _auth;

  @override
  Stream<BaseUseCaseResponse> invoke({required String title, required String content, required DateTime date}) async* {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      yield BaseUseCaseResponse(error: 'User not authenticated');
      return;
    }

    final JournalEntry entry = JournalEntry(
      title: title,
      content: content,
      userId: userId,
      date: Timestamp.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
    );

    try {
      yield BaseUseCaseResponse(isLoading: true);
      await _journalRepo.addJournalEntry(entry: entry);
      yield BaseUseCaseResponse(isLoading: false);
    } catch (e) {
      yield BaseUseCaseResponse(error: e.toString());
    }
  }
}
