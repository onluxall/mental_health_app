import 'package:mental_health_app/data/chat/data.dart';

abstract class IChatRepo {
  Future sendMessage({required String message, required String? userId, required String? chatId, required bool isNewChat, required ChatMessageType sender});
  Stream<List<ChatHistory>> observeAllUserChats({required String userId});
}
