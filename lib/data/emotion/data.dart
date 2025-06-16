import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'emotions.dart';

part 'data.g.dart';

@JsonSerializable()
class EmotionData {
  final String? id;
  final String? userId;
  final EmotionLevel emotionLevel;
  final List<String> emotionsChosen;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp date;

  EmotionData({
    this.id,
    required this.emotionLevel,
    required this.emotionsChosen,
    this.userId,
    required this.date,
  });

  EmotionData copyWith({
    String? id,
    EmotionLevel? emotionLevel,
    List<String>? emotionsChosen,
    String? userId,
    Timestamp? date,
  }) {
    return EmotionData(
      id: id ?? this.id,
      emotionLevel: emotionLevel ?? this.emotionLevel,
      emotionsChosen: emotionsChosen ?? this.emotionsChosen,
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }

  static Timestamp _fromJson(Timestamp timestamp) => timestamp;
  static Timestamp _toJson(Timestamp timestamp) => timestamp;

  factory EmotionData.fromJson(Map<String, dynamic> json) => _$EmotionDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionDataToJson(this);
}
