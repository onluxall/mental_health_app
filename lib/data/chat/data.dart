import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ChatHistory {
  final String? chatId;
  final String? userId;
  final String? title;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp? createdAt;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp? updatedAt;
  final List<ChatMessage>? messages;

  ChatHistory({
    this.chatId,
    this.userId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.messages,
  });

  // TODO create the fromJson and toJson methods globally
  static Timestamp _fromJson(Timestamp? timestamp) => timestamp ?? Timestamp.now();
  static Timestamp _toJson(Timestamp? timestamp) => timestamp ?? Timestamp.now();

  factory ChatHistory.fromJson(Map<String, dynamic> json) => _$ChatHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);
}

@JsonSerializable()
class ChatMessage {
  final ChatMessageType? sender;
  final String? content;
  final DateTime? createdAt;

  ChatMessage({
    this.sender,
    this.content,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

enum ChatMessageType {
  user,
  assistant,
}
