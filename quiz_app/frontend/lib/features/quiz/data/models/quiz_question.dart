class QuizQuestion {
  final String category;
  final String question;
  final String answer;
  final String? fact; // Optional - für Fun Facts

  QuizQuestion({
    required this.category,
    required this.question,
    required this.answer,
    this.fact,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      category: json['category'] ?? 'Unbekannt',
      question: json['question'] ?? 'Fehler beim Laden',
      answer: json['answer'] ?? '',
      fact: json['fact'], // Kann null sein
    );
  }
}