import 'package:injectable/injectable.dart';

import '../../data/journal/interface.dart';
import '../base_use_case_response.dart';

abstract class IUpdateJournalEntryUseCase {
  Stream<BaseUseCaseResponse> invoke({required String id, required String title, required String content});
}

@Injectable(as: IUpdateJournalEntryUseCase)
class UpdateJournalEntryUseCase extends IUpdateJournalEntryUseCase {
  UpdateJournalEntryUseCase(this._journalRepo);
  final IJournalRepo _journalRepo;

  @override
  Stream<BaseUseCaseResponse> invoke({required String id, required String title, required String content}) async* {
    try {
      yield BaseUseCaseResponse(isLoading: true);
      await _journalRepo.updateJournalEntry(id: id, title: title, content: content);
      yield BaseUseCaseResponse(isLoading: false);
    } catch (e) {
      yield BaseUseCaseResponse(error: e.toString());
    }
  }
}
