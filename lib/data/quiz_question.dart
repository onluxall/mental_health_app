class QuizQuestion {
  final String question;
  double value;

  QuizQuestion({
    required this.question,
    required this.value,
  });

  QuizQuestion copyWith({
    String? question,
    double? value,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      value: value ?? this.value,
    );
  }
} 