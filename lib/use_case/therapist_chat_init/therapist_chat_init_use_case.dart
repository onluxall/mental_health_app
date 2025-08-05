import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/use_case/therapist_chat_init/therapist_chat_init_response.dart';

import '../../data/chat/interface.dart';

abstract class ITherapistChatInitUseCase {
  Stream<TherapistInitResponse> invoke();
}

@Injectable(as: ITherapistChatInitUseCase)
class TherapistChatInitUseCase implements ITherapistChatInitUseCase {
  TherapistChatInitUseCase(this._chatRepo);

  final IChatRepo _chatRepo;

  @override
  Stream<TherapistInitResponse> invoke() async* {
    yield TherapistInitResponse(isLoading: true);
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final stream = _chatRepo.observeAllUserChats(userId: userId);
      await for (final response in stream) {
        yield TherapistInitResponse(isLoading: false, chats: response);
      }
      yield TherapistInitResponse(isLoading: false);
    } catch (e) {
      yield TherapistInitResponse(isLoading: false, error: e.toString());
    }
  }
}
