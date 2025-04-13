import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

class TaskCategory {
  final String name;
  final String color;

  TaskCategory({required this.name, required this.color});
}

class TaskType {
  final String name;
  final String description;
  final DateTime? duration;
  final IconData icon;
  final TaskCategory taskCategory;

  TaskType({required this.description, required this.duration, required this.taskCategory, required this.name, required this.icon});
}

@JsonSerializable()
class UserTask {
  final String id;
  final TaskType taskType;
  final DateTime? startDate;
  final DateTime? endDate;

  UserTask({required this.id, required this.taskType, required this.startDate, required this.endDate});
}
