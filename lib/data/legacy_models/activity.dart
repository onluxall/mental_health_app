class Activity {
  final String id;
  final String title;
  final String description;
  final int estimatedMinutes;
  final List<String> tags;
  final bool isSaved;
  final String? note;
  final DateTime? completedAt;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.tags,
    this.isSaved = false,
    this.note,
    this.completedAt,
  });

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    int? estimatedMinutes,
    List<String>? tags,
    bool? isSaved,
    String? note,
    DateTime? completedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tags: tags ?? this.tags,
      isSaved: isSaved ?? this.isSaved,
      note: note ?? this.note,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'estimatedMinutes': estimatedMinutes,
      'tags': tags,
      'isSaved': isSaved,
      'note': note,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      tags: List<String>.from(json['tags'] as List),
      isSaved: json['isSaved'] as bool,
      note: json['note'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
} 