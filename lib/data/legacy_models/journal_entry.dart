class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final List<String> tags;
  final double mood;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.tags = const [],
    this.mood = 3.0, // Default to "Okay"
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'mood': mood,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      mood: json['mood'] as double? ?? 3.0,
    );
  }
}
