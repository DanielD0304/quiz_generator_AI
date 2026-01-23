import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/quiz_provider.dart';
import '../../data/repos/quiz_service.dart';
import '../widgets/question_dialog.dart';
import '../../../../core/category_icons.dart';

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

// Spielbrett mit 3x Spalten und ewigen Fragen
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
  // Wir speichern den Zustand lokal: Welche Fragen haben wir aktuell?
  late Map<String, dynamic> activeQuestions;
  // Welche Kategorien laden gerade nach?
  final Set<String> loadingCategories = {};

  @override
  void initState() {
    super.initState();
    activeQuestions = Map.from(widget.questionsMap);
  }

  // Funktion zum Nachladen einer Kategorie
  Future<void> refillCategory(String category) async {
    setState(() {
      loadingCategories.add(category);
    });

    try {
      final quizService = QuizService();
      final newQuestion = await quizService.fetchSingleQuestion(category);
      
      if (mounted) {
        setState(() {
          // Wir überschreiben die alte Frage mit der neuen
          activeQuestions[category] = newQuestion; 
          loadingCategories.remove(category);
        });
      }
    } catch (e) {
      print("Fehler beim Refill: $e");
      if (mounted) {
        setState(() => loadingCategories.remove(category));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // GridView sortiert nach Alphabet, damit man die Steine schnell findet
    final sortedCategories = List<String>.from(widget.categories)..sort();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 Spalten sind besser lesbar bei 16 Kategorien
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final category = sortedCategories[index];
        final question = activeQuestions[category];
        final isLoading = loadingCategories.contains(category);

        return _CategoryCard(
          category: category,
          isLoading: isLoading,
          onTap: () async {
            if (isLoading || question == null) return;

            // 1. Dialog zeigen
            await showDialog(
              context: context,
              builder: (context) => QuestionDialog(question: question),
            );

            // 2. Sobald Dialog zu ist -> SOFORT Nachladen im Hintergrund
            refillCategory(category);
          },
        );
      },
    );
  }
}

// Kleine Hilfs-Widget für die Optik
class _CategoryCard extends StatelessWidget {
  final String category;
  final bool isLoading;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = CategoryHelper.getIcon(category);
    final color = CategoryHelper.getColor(category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.6),
                color.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon im Hintergrund (transparent)
              Opacity(
                opacity: 0.15,
                child: Icon(
                  icon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              // Inhalt in der Mitte
              Center(
                child: isLoading
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Nachfüllen...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 32,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              category,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
