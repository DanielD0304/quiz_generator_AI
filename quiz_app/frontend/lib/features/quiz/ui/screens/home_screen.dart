import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/quiz_provider.dart';
import 'category_screen.dart';

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
              'Quiz AI',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Generator',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: Colors.tealAccent,
              ),
            ),
            const SizedBox(height: 48),
            // Beschreibung
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Generiere intelligente Quizfragen\nmit KI zu verschiedenen Kategorien',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Start Button
            ElevatedButton(
              onPressed: () {
                // Neue Fragen laden bevor zur CategoryScreen navigiert wird
                ref.read(quizProvider.notifier).loadGame();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              child: Text(
                'Quiz Starten',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
