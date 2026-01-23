import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';
import 'dart:io' show Platform;

class QuizService {
  String get baseUrl {
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://localhost:8000";
  }

  Future<List<QuizQuestion>> fetchRound({String difficulty = "medium"}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/prepare-round?difficulty=$difficulty"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List questionsList = data['questions'];
        return questionsList.map((q) => QuizQuestion.fromJson(q)).toList();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Verbindungsfehler: $e");
    }
  }

  Future<QuizQuestion> fetchSingleQuestion(String category, {String difficulty = "medium"}) async {
    try {
      final encodedCategory = Uri.encodeComponent(category);
      final response = await http.get(
        Uri.parse("$baseUrl/refill?category=$encodedCategory&difficulty=$difficulty"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return QuizQuestion.fromJson(data);
      } else {
        throw Exception("Fehler beim Nachladen");
      }
    } catch (e) {
      throw Exception("Refill Error: $e");
    }
  }
}