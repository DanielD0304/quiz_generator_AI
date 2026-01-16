import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/quiz_question.dart';
import '../data/repos/quiz_service.dart';

// Dieser Provider wird von der UI beobachtet
final quizProvider = StateNotifierProvider<QuizNotifier, AsyncValue<Map<String, QuizQuestion>>>((ref) {
  return QuizNotifier(QuizService());
});

class QuizNotifier extends StateNotifier<AsyncValue<Map<String, QuizQuestion>>> {
  final QuizService _service;

  QuizNotifier(this._service) : super(const AsyncValue.loading()) {
    // Startet das Laden sofort bei App-Start
    loadGame();
  }

  Future<void> loadGame() async {
    state = const AsyncValue.loading();
    try {
      final questions = await _service.fetchRound();
      // Wir wandeln die Liste in eine Map um für schnelleren Zugriff
      final Map<String, QuizQuestion> questionsMap = {
        for (var item in questions) item.category : item
      };
      state = AsyncValue.data(questionsMap);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}