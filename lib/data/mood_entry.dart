enum MoodLevel {
  terrible,
  bad,
  okay,
  good,
  great,
}

class MoodEntry {
  final DateTime timestamp;
  final MoodLevel moodLevel;
  final List<String> emotions;
  final String? note;

  MoodEntry({
    required this.timestamp,
    required this.moodLevel,
    required this.emotions,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'moodLevel': moodLevel.toString(),
      'emotions': emotions,
      'note': note,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      moodLevel: MoodLevel.values.firstWhere(
        (e) => e.toString() == json['moodLevel'],
      ),
      emotions: List<String>.from(json['emotions'] as List),
      note: json['note'] as String?,
    );
  }
} 