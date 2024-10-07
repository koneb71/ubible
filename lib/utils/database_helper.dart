import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    try {
      // Check if the database exists
      bool exists = await databaseExists(path);

      if (!exists) {
        // Copy from assets
        ByteData data = await rootBundle.load('assets/bible.db');
        List<int> bytes = data.buffer.asUint8List();

        // Write the bytes to the file
        await File(path).writeAsBytes(bytes, flush: true);
        print('Database copied to $path');
      } else {
        print('Database already exists at $path');
      }

      // Open the database
      // return await openDatabase(path, version: _databaseVersion);
      return await databaseFactory.openDatabase(path);
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // Optionally, rethrow to handle it further up the call stack
    }
  }
}
