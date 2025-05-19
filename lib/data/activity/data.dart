import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

enum ActivityCategory {
  mindfulness,
  creative,
  social,
  active,
}

@JsonSerializable()
class Activity {
  final String? id;
  final String title;
  final String? description;
  final String duration;
  final String? category;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp createdAt;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp? completedAt;
  final String? userId;
  final bool isRecommended;
  final String? note;

  Activity({
    this.id,
    required this.title,
    this.description,
    required this.duration,
    this.category,
    required this.createdAt,
    this.note,
    this.completedAt,
    this.userId,
    this.isRecommended = false,
  });

  // TODO create the fromJson and toJson methods globally
  static Timestamp _fromJson(Timestamp? timestamp) => timestamp ?? Timestamp.now();
  static Timestamp _toJson(Timestamp? timestamp) => timestamp ?? Timestamp.now();

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  copyWith({String? userId}) {
    return Activity(
      id: id,
      title: title,
      description: description,
      duration: duration,
      category: category,
      createdAt: createdAt,
      note: note,
      completedAt: completedAt,
      userId: userId ?? this.userId,
      isRecommended: isRecommended,
    );
  }
}

Color getCategoryColor(ActivityCategory category) {
  switch (category) {
    case ActivityCategory.mindfulness:
      return Colors.purple;
    case ActivityCategory.creative:
      return Colors.red;
    case ActivityCategory.social:
      return Colors.blue;
    case ActivityCategory.active:
      return Colors.green;
  }
}

ActivityCategory getCategoryFromString(String category) {
  switch (category) {
    case 'mindfulness':
      return ActivityCategory.mindfulness;
    case 'creative':
      return ActivityCategory.creative;
    case 'social':
      return ActivityCategory.social;
    case 'active':
      return ActivityCategory.active;
    default:
      return ActivityCategory.mindfulness;
  }
}

IconData getCategoryIcon(ActivityCategory category) {
  switch (category) {
    case ActivityCategory.mindfulness:
      return Icons.self_improvement;
    case ActivityCategory.creative:
      return Icons.brush;
    case ActivityCategory.social:
      return Icons.people;
    case ActivityCategory.active:
      return Icons.fitness_center;
  }
}
