import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'package:sqlite3/sqlite3.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final _databaseName = "bible.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();

    return _database!;
  }

  _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);

    // Check if the database already exists
    if (!File(path).existsSync()) {
      print('Copying database from assets to $path');

      // Ensure the directory exists
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (e) {
        print('Error creating directory: $e');
      }

      // Load database from assets
      final data = await rootBundle.load('assets/$_databaseName');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the bytes to the file
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('Opening existing database at $path');
    }

    // Open the database using sqlite3
    final db = sqlite3.open(path);
    return db;
  }
}
