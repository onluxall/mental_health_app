class UserProfile {
  final String name;
  final Map<String, dynamic> quizResults;
  final bool hasCompletedQuiz;
  final String preferredLanguage;
  final bool isDarkMode;

  UserProfile({
    required this.name,
    required this.quizResults,
    this.hasCompletedQuiz = false,
    this.preferredLanguage = 'en',
    this.isDarkMode = false,
  });

  UserProfile copyWith({
    String? name,
    Map<String, dynamic>? quizResults,
    bool? hasCompletedQuiz,
    String? preferredLanguage,
    bool? isDarkMode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      quizResults: quizResults ?? this.quizResults,
      hasCompletedQuiz: hasCompletedQuiz ?? this.hasCompletedQuiz,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quizResults': quizResults,
      'hasCompletedQuiz': hasCompletedQuiz,
      'preferredLanguage': preferredLanguage,
      'isDarkMode': isDarkMode,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      quizResults: json['quizResults'] as Map<String, dynamic>,
      hasCompletedQuiz: json['hasCompletedQuiz'] as bool,
      preferredLanguage: json['preferredLanguage'] as String,
      isDarkMode: json['isDarkMode'] as bool,
    );
  }
} 