class QuizQuestion {
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers; // Enthält Richtige + Falsche gemischt
  final String fact;

  QuizQuestion({
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
    required this.fact,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // 1. Liste kopieren, damit wir sie bearbeiten können
    List<String> answers = List<String>.from(json['distractors'] ?? []);
    // 2. Richtige Antwort hinzufügen
    answers.add(json['answer']);
    // 3. Mischen (Shuffle), damit die Lösung nicht immer unten steht
    answers.shuffle();

    return QuizQuestion(
      category: json['category'] ?? 'Unbekannt',
      question: json['question'] ?? 'Fehler beim Laden',
      correctAnswer: json['answer'] ?? '',
      allAnswers: answers,
      fact: json['fact'] ?? '',
    );
  }
}