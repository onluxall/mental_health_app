part of 'therapist_chat_bloc.dart';

abstract class TherapistChatEvent extends BaseEvent {
  TherapistChatEvent({super.isLoading, super.error});
}

class TherapistChatInit extends TherapistChatEvent {}

class TherapistChatChangeText extends TherapistChatEvent {
  final String text;

  TherapistChatChangeText({required this.text});
}

class TherapistChatSendMessage extends TherapistChatEvent {
  TherapistChatSendMessage({super.isLoading, super.error});
}

class TherapistChatSelectChat extends TherapistChatEvent {
  final ChatHistory? chat;

  TherapistChatSelectChat({required this.chat});
}
