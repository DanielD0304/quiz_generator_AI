import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/quiz_provider.dart';
import '../widgets/question_dialog.dart';

class StoneQuizGameScreen extends ConsumerWidget {
  const StoneQuizGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: Text("Stone Quiz Game", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.tealAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: quizState.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.tealAccent),
              SizedBox(height: 20),
              Text("Generiere Runde... (ca. 4-6 Sek)", style: TextStyle(color: Colors.white54))
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Fehler: $err", style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () => ref.read(quizProvider.notifier).loadGame(),
                child: const Text("Erneut versuchen"),
              )
            ],
          ),
        ),
        data: (questionsMap) {
          final categories = questionsMap.keys.toList();
          return GameBoard(categories: categories, questionsMap: questionsMap);
        },
      ),
    );
  }
}

// Spielbrett mit 4x4 Grid
class GameBoard extends StatefulWidget {
  final List<String> categories;
  final Map<String, dynamic> questionsMap;

  const GameBoard({
    required this.categories,
    required this.questionsMap,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final Set<int> answeredQuestions = {};
  int currentPlayerScore = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Score Display
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Punkte: $currentPlayerScore",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Quiz Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final isAnswered = answeredQuestions.contains(index);
              return _QuizStone(
                index: index,
                category: widget.categories[index],
                isAnswered: isAnswered,
                onTap: () {
                  if (!isAnswered) {
                    final question = widget.questionsMap[widget.categories[index]];
                    if (question != null) {
                      showDialog(
                        context: context,
                        builder: (context) => QuestionDialog(question: question),
                      ).then((_) {
                        // Nach Antwort: Stein markieren als beantwortet
                        setState(() {
                          answeredQuestions.add(index);
                        });
                      });
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Einzelner Quiz-Stein
class _QuizStone extends StatelessWidget {
  final int index;
  final String category;
  final bool isAnswered;
  final VoidCallback onTap;

  const _QuizStone({
    required this.index,
    required this.category,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: isAnswered
                ? LinearGradient(
                    colors: [Colors.grey.shade700, Colors.grey.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.amber.shade600, Colors.amber.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Kategorie-Text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: isAnswered ? Colors.white38 : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Checkmark wenn beantwortet
              if (isAnswered)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade400,
                  size: 32,
                )
            ],
          ),
        ),
      ),
    );
  }
}
