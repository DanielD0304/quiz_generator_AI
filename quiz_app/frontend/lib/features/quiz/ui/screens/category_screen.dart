import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/quiz_provider.dart';
import '../widgets/question_dialog.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hier hören wir auf den Provider
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Dunkles, edles Theme
      appBar: AppBar(
        title: Text("Quiz AI Generator", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.tealAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: quizState.when(
        // 1. Ladezustand
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
        // 2. Fehlerzustand
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
        // 3. Daten sind da!
        data: (questionsMap) {
          final categories = questionsMap.keys.toList();
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 Spalten
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                categoryName: category,
                onTap: () {
                  final question = questionsMap[category];
                  
                  if (question != null) {
                    showDialog(
                      context: context,
                      builder: (context) => QuestionDialog(question: question),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Ein schönes Widget für die Kacheln
class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final VoidCallback onTap;

  const _CategoryCard({required this.categoryName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4))
            ],
          ),
          child: Center(
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}