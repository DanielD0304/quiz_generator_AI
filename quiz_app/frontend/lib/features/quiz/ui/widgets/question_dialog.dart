import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/quiz_question.dart';

class QuestionDialog extends StatefulWidget {
  final QuizQuestion question;

  const QuestionDialog({super.key, required this.question});

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  bool isAnswerRevealed = false; // Wurde die Antwort schon angezeigt?

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2D2D44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Die Kategorie als Überschrift
            Text(
              widget.question.category.toUpperCase(),
              style: GoogleFonts.poppins(
                color: Colors.tealAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Die Frage
            Text(
              widget.question.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Wenn Antwort noch nicht gezeigt: Button zum Anzeigen
            if (!isAnswerRevealed) ...[
              ElevatedButton(
                onPressed: () => setState(() => isAnswerRevealed = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Antwort anzeigen",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]
            // 4. Wenn Antwort gezeigt: Die Lösung + Fact anzeigen
            else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade600, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      "RICHTIGE ANTWORT",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade200,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.question.correctAnswer,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Der "Fact" (Wissenswertes)
              const Divider(color: Colors.white24, height: 0),
              const SizedBox(height: 16),
              Text(
                "WUSSTEST DU SCHON?",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.question.fact,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  "Weiter",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}