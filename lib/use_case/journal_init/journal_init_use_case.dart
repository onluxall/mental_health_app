import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/journal/interface.dart';

import 'journal_init_response.dart';

abstract class IJournalInitUseCase {
  Stream<JournalInitResponse> invoke();
}

@Injectable(as: IJournalInitUseCase)
class JournalInitUseCase extends IJournalInitUseCase {
  JournalInitUseCase(this._auth, this._journalRepo);
  final FirebaseAuth _auth;
  final IJournalRepo _journalRepo;
  @override
  Stream<JournalInitResponse> invoke() async* {
    try {
      yield JournalInitResponse(isLoading: true);
      final userId = _auth.currentUser?.uid;
      final stream = _journalRepo.observeJournalEntriesByUser(userId: userId ?? "");
      await for (var result in stream) {
        yield JournalInitResponse(journalEntries: result);
      }
    } catch (e) {
      yield JournalInitResponse(error: e.toString());
    }
  }
}
