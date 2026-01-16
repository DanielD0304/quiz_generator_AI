import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';
import 'dart:io' show Platform;

class QuizService {
  // Android Emulator braucht 10.0.2.2, iOS Simulator braucht localhost
  String get baseUrl {
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://localhost:8000";
  }

  Future<List<QuizQuestion>> fetchRound() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/prepare-round"));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)); // utf8 fix für Umlaute!
        final List questionsList = data['questions'];
        return questionsList.map((q) => QuizQuestion.fromJson(q)).toList();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Verbindungsfehler: $e");
    }
  }
}