import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/chat/data.dart';
import 'package:mental_health_app/data/chat/interface.dart';

@Injectable(as: IChatRepo)
class ChatRepo implements IChatRepo {
  final _chatsDB = FirebaseFirestore.instance.collection('chats');

  @override
  Stream<List<ChatHistory>> observeAllUserChats({required String userId}) async* {
    yield* _chatsDB.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChatHistory.fromJson(doc.data())).toList();
    });
  }

  @override
  Future sendMessage(
      {required String message, required String? userId, required String? chatId, required bool isNewChat, required ChatMessageType sender}) async {
    if (isNewChat) {
      final ref = await _chatsDB.add({
        'userId': userId,
        'createdAt': DateTime.now(),
        'title': getFirstTwoWords(message),
        'messages': [
          ChatMessage(
            sender: sender,
            content: message,
            createdAt: DateTime.now(),
          ).toJson(),
        ],
      });
      _chatsDB.doc(ref.id).update({
        'chatId': ref.id,
      });
    } else {
      _chatsDB.doc(chatId).update({
        'updatedAt': DateTime.now(),
        'messages': FieldValue.arrayUnion([
          ChatMessage(
            sender: sender,
            content: message,
            createdAt: DateTime.now(),
          ).toJson(),
        ]),
      });
    }
  }
}

String getFirstTwoWords(String text) {
  if (text.isEmpty) return '';

  List<String> words = text.trim().split(RegExp(r'\s+'));
  if (words.length <= 2) {
    return text.trim();
  }
  return words.take(2).join(' ');
}
