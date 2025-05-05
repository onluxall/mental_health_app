// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) => JournalEntry(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: JournalEntry._fromJson(json['date'] as Timestamp),
    );

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'date': JournalEntry._toJson(instance.date),
    };
