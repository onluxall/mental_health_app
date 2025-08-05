part of 'therapist_chat_bloc.dart';

class TherapistChatState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? text;
  final List<ChatHistory> chats;
  final ChatHistory? currentChat;

  const TherapistChatState({
    this.text,
    this.chats = const [],
    this.currentChat,
    this.isLoading = false,
    this.error,
  });

  TherapistChatState copyWith({
    String? text,
    List<ChatHistory>? chats,
    ChatHistory? currentChat,
    bool? isLoading,
    String? error,
    bool isNewChat = false,
  }) {
    return TherapistChatState(
      text: text ?? this.text,
      chats: chats ?? this.chats,
      currentChat: isNewChat ? null : currentChat ?? this.currentChat,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        text,
        chats,
        currentChat,
        isLoading,
        error,
      ];
}
