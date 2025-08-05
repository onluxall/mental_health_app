import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/chat/interface.dart';
import 'package:mental_health_app/use_case/base_use_case_response.dart';

import '../../data/chat/data.dart';

abstract class ITherapistChatAddUseCase {
  Stream<BaseUseCaseResponse> invoke({required String message, required bool isNewChat, required String? chatId});
}

@Injectable(as: ITherapistChatAddUseCase)
class TherapistChatAddUseCase implements ITherapistChatAddUseCase {
  TherapistChatAddUseCase(this._chatRepo);

  final IChatRepo _chatRepo;

  @override
  Stream<BaseUseCaseResponse> invoke({required String message, required bool isNewChat, required String? chatId}) async* {
    yield BaseUseCaseResponse(isLoading: true);
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      await _chatRepo.sendMessage(message: message, isNewChat: isNewChat, userId: userId, chatId: chatId, sender: ChatMessageType.user);
      Gemini.init(apiKey: dotenv.env['GOOGLE_API_KEY'] ?? "");
      await Gemini.instance.prompt(parts: [
        Part.text(message),
      ]).then((value) async {
        await _chatRepo.sendMessage(message: value?.output ?? "", isNewChat: isNewChat, userId: null, chatId: chatId, sender: ChatMessageType.assistant);
      });
      yield BaseUseCaseResponse(isLoading: false);
    } catch (e) {
      yield BaseUseCaseResponse(isLoading: false, error: e.toString());
    }
  }
}
