class QuizQuestion {
  final String category;
  final String question;
  final String answer;

  QuizQuestion({
    required this.category,
    required this.question,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      category: json['category'] ?? 'Unbekannt',
      question: json['question'] ?? 'Fehler beim Laden',
      answer: json['answer'] ?? '',
    );
  }
}