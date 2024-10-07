import 'package:flutter/material.dart';
import 'package:ubible/screens/verse_list_screen.dart';
import 'package:ubible/utils/database_helper.dart';

class ChapterListScreen extends StatefulWidget {
  final String book;

  const ChapterListScreen({Key? key, required this.book}) : super(key: key);

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Future<List<int>> _chapters;

  @override
  void initState() {
    super.initState();
    _chapters = _fetchChapters();
  }

  Future<List<int>> _fetchChapters() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.rawQuery(
      'SELECT DISTINCT chapter FROM ceb_content WHERE book = ?',
      [widget.book],
    );
    return maps.map((map) => map['chapter'] as int).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.book),
        ),
        body: FutureBuilder<List<int>>(
          future: _chapters,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final chapters = snapshot.data!;
                return ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return ListTile(
                      title: Text('Chapter $chapter'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerseListScreen(
                              book: widget.book,
                              chapter: chapter,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(child: Text('No chapters found.'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
