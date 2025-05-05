import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class JournalEntry {
  final String? id;
  final String userId;
  final String title;
  final String content;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp date;

  JournalEntry({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.date,
  });

  static Timestamp _fromJson(Timestamp timestamp) => timestamp;
  static Timestamp _toJson(Timestamp timestamp) => timestamp;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);
}
