import 'package:flutter/material.dart';
import '../models/verse.dart';
import 'package:ubible/utils/database_helper.dart';
import 'package:ubible/screens/verse_list_screen.dart'; // Optional: if you have a detail screen

class BibleSearchDelegate extends SearchDelegate<Verse> {
  // Override the search bar's right-side actions
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  // Override the search bar's left-side icon (back button)
  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(onPressed: () {
      Navigator.pop(context);
    });
  }

  // Override the results shown when the user submits a search term
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Verse>>(
      future: _search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final results = snapshot.data!;
            if (results.isEmpty) {
              return const Center(child: Text('No results found.'));
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final verse = results[index];
                return ListTile(
                  title: Text(verse.passage),
                  subtitle: Text(
                      'Book ${verse.book}, Chapter ${verse.chapter}, Verse ${verse.verse}'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseListScreen(
                          book: verse.book,
                          chapter: verse.chapter,
                          initialVerse: verse.verse,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('No results found.'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Override the suggestions shown while the user types
  @override
  Widget buildSuggestions(BuildContext context) {
    // Optionally, implement suggestions here
    return Container();
  }

  // Perform the search using the query
  Future<List<Verse>> _search(String query) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.rawQuery(
      '''
      SELECT CAST(rowid as UNSIGNED) id, book, chapter, verse, passage
      FROM ceb_content_fts WHERE passage MATCH ?
      ORDER BY rank
      ''',
      [query],
    );
    return maps.map((map) => Verse.fromMap(map)).toList();
  }
}
