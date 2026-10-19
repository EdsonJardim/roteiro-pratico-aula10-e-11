
import 'package:flutter/material.dart';

import 'screens/feed_noticias_screen.dart';

void main() {
  runApp(const AgroNoticiasApp());
}

class AgroNoticiasApp extends StatelessWidget {
  const AgroNoticiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aulas 10 e 11 - Notícias',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const FeedNoticiasScreen(),
    );
  }
}
