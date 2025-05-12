// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// @JsonSerializable()
// class TaskCategory {
//   final String name;
//   final String color;
//
//   TaskCategory({required this.name, required this.color});
// }
//
// @JsonSerializable()
// class TaskType {
//   final String name;
//   final String description;
//   final DateTime? duration;
//   final TaskCategory taskCategory;
//
//   TaskType({
//     required this.description,
//     required this.duration,
//     required this.taskCategory,
//     required this.name,
//   });
// }
//
// @JsonSerializable()
// class UserTask {
//   final String id;
//   final TaskType taskType;
//   final DateTime? startDate;
//   final DateTime? endDate;
//
//   UserTask({required this.id, required this.taskType, required this.startDate, required this.endDate});
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class UserTask {
  final String? id;
  final String? userId;
  final String title;
  final String duration;
  final bool? isCompleted;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp date;

  UserTask({this.id, this.userId, required this.title, required this.duration, this.isCompleted, required this.date});

  static Timestamp _fromJson(Timestamp timestamp) => timestamp;
  static Timestamp _toJson(Timestamp timestamp) => timestamp;

  factory UserTask.fromJson(Map<String, dynamic> json) => _$UserTaskFromJson(json);

  Map<String, dynamic> toJson() => _$UserTaskToJson(this);
}
