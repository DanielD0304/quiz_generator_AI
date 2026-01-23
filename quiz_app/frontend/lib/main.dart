import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/quiz/ui/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}