import 'package:flutter/material.dart';
import 'package:poetry/screens/poetry_title_page.dart';
import 'package:poetry/screens/poetry_title_page_alternative.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PoetryTitleAlternativePage(),
    );
  }
}

