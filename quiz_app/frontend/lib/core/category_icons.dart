import 'package:flutter/material.dart';

class CategoryHelper {
  static IconData getIcon(String category) {
    // Anpassungen für deine aktuellen 16 Kategorien
    switch (category.toLowerCase()) {
      case "architektur":
        return Icons.apartment;
      case "art":
      case "kunst":
        return Icons.brush;
      case "design":
        return Icons.palette;
      case "essen & trinken":
      case "essen":
        return Icons.restaurant;
      case "film & fernsehen":
      case "film":
        return Icons.movie;
      case "geografie":
      case "geographie":
        return Icons.public;
      case "geschichte":
        return Icons.history_edu;
      case "gesellschaft":
      case "mensch":
        return Icons.groups;
      case "kunst & bühne":
        return Icons.theater_comedy;
      case "literatur":
        return Icons.menu_book;
      case "musik":
        return Icons.music_note;
      case "natur":
      case "naturwissenschaft":
        return Icons.forest;
      case "politik":
        return Icons.account_balance;
      case "sport":
        return Icons.sports_soccer;
      case "spiel":
        return Icons.extension;
      case "sprache":
        return Icons.record_voice_over;
      case "technik":
        return Icons.memory;
      case "tv & radio":
        return Icons.tv;
      case "wirtschaft":
      case "mode":
        return Icons.trending_up;
      case "religion":
        return Icons.auto_awesome;
      default:
        return Icons.help_outline;
    }
  }

  static Color getColor(String category) {
    // Verschiedene Farben pro Kategorie für mehr Vielfalt
    switch (category.toLowerCase()) {
      case "architektur":
        return Colors.blueGrey;
      case "art":
      case "kunst":
        return Colors.purple;
      case "design":
        return Colors.pink;
      case "essen & trinken":
      case "essen":
        return Colors.orange;
      case "film & fernsehen":
      case "film":
        return Colors.red;
      case "geografie":
      case "geographie":
        return Colors.cyan;
      case "geschichte":
        return Colors.amber;
      case "gesellschaft":
      case "mensch":
        return Colors.green;
      case "kunst & bühne":
        return Colors.indigo;
      case "literatur":
        return Colors.brown;
      case "musik":
        return Colors.lime;
      case "natur":
      case "naturwissenschaft":
        return Colors.teal;
      case "politik":
        return Colors.deepOrange;
      case "sport":
        return Colors.lightGreen;
      case "spiel":
        return Colors.blue;
      case "sprache":
        return Colors.cyan;
      case "technik":
        return Colors.lightBlue;
      case "tv & radio":
        return Colors.blueAccent;
      case "wirtschaft":
      case "mode":
        return Colors.pink;
      case "religion":
        return Colors.deepPurple;
      default:
        return Colors.tealAccent;
    }
  }
}
