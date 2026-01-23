import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/quiz_provider.dart';
import 'category_screen.dart';
import 'stone_quiz_game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Titel
            Icon(
              Icons.quiz,
              size: 80,
              color: Colors.tealAccent,
            ),
            const SizedBox(height: 24),
            Text(
              'Quiz Arena',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Wähle deinen Modus',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.tealAccent,
              ),
            ),
            const SizedBox(height: 60),

            // Modus 1: Quiz AI Generator
            _ModeButton(
              icon: Icons.auto_awesome,
              title: "Quiz AI Generator",
              subtitle: "Generiere KI-Fragen\nfür dein Bezzerwizzer",
              color: Colors.teal,
              onTap: () {
                ref.read(quizProvider.notifier).loadGame();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Modus 2: Stone Quiz Game
            _ModeButton(
              icon: Icons.games,
              title: "Stone Quiz Game",
              subtitle: "Spiele Bezzerwizzer\nvirtuelle Variante",
              color: Colors.amber,
              onTap: () {
                ref.read(quizProvider.notifier).loadGame();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StoneQuizGameScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Wiederverwendbarer Button für die Modi
class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
