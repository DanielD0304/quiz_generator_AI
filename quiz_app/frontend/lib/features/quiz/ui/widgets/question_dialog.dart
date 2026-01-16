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
  String? selectedAnswer;
  bool isRevealed = false; // Wurde schon aufgelöst?

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

            // 3. Die Antwort-Buttons
            ...widget.question.allAnswers.map((answer) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnswerButton(
                  text: answer,
                  state: _getButtonState(answer),
                  onTap: () => _handleAnswer(answer),
                ),
              );
            }),

            // 4. Der "Fact" (erscheint erst nach Antwort)
            if (isRevealed) ...[
              const Divider(color: Colors.white24, height: 30),
              Text(
                "WUSSTEST DU SCHON?",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.question.fact,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), // Fenster schließen
                child: const Text("Weiter"),
              )
            ]
          ],
        ),
      ),
    );
  }

  // Logik: Welche Farbe hat der Button?
  AnswerState _getButtonState(String answer) {
    if (!isRevealed) return AnswerState.neutral;
    if (answer == widget.question.correctAnswer) return AnswerState.correct;
    if (answer == selectedAnswer && answer != widget.question.correctAnswer) return AnswerState.wrong;
    return AnswerState.disabled;
  }

  void _handleAnswer(String answer) {
    if (isRevealed) return; // Nichts tun, wenn schon geantwortet wurde
    setState(() {
      selectedAnswer = answer;
      isRevealed = true;
    });
  }
}

// --- Hilfs-Widgets ---

enum AnswerState { neutral, correct, wrong, disabled }

class _AnswerButton extends StatelessWidget {
  final String text;
  final AnswerState state;
  final VoidCallback onTap;

  const _AnswerButton({required this.text, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (state) {
      case AnswerState.correct:
        bgColor = Colors.green.shade700;
        break;
      case AnswerState.wrong:
        bgColor = Colors.red.shade700;
        break;
      case AnswerState.disabled:
        bgColor = Colors.white10;
        textColor = Colors.white38;
        break;
      default:
        bgColor = Colors.white12;
    }

    return GestureDetector(
      onTap: state == AnswerState.disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: state == AnswerState.neutral 
              ? Border.all(color: Colors.white24) 
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: textColor, fontSize: 14),
        ),
      ),
    );
  }
}