import 'package:flutter/material.dart';
import 'package:ubible/screens/book_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const BibleApp());
}

class BibleApp extends StatelessWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.blue,
    );
    return MaterialApp(
      title: 'Bible App',
      theme: theme,
      home: const BookListScreen(),
    );
  }
}
