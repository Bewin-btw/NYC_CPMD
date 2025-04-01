import 'package:flutter/material.dart';
import 'about_page.dart'; // Подключаем AboutPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // убираем DEBUG-ленту
      title: 'Truth or Action',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AboutPage(), // Вот здесь подключается твоя страница
    );
  }
}
