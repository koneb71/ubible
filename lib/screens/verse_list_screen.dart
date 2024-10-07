import 'package:flutter/material.dart';
import 'package:ubible/models/verse.dart';
import 'package:ubible/utils/database_helper.dart';

class VerseListScreen extends StatefulWidget {
  final String book;
  final int chapter;
  final int? initialVerse;

  const VerseListScreen({
    super.key,
    required this.book,
    required this.chapter,
    this.initialVerse,
  });

  @override
  _VerseListScreenState createState() => _VerseListScreenState();
}

class _VerseListScreenState extends State<VerseListScreen> {
  late Future<List<Verse>> _verses;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _verses = _fetchVerses();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Verse>> _fetchVerses() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.select(
      'select * from ceb_content where book ? and chapter ?',
      [widget.book, widget.chapter],
    );
    return maps.map((map) => Verse.fromMap(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book} Chapter ${widget.chapter}'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: _verses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final verses = snapshot.data!;

              // Scroll to initial verse
              if (widget.initialVerse != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final index =
                      verses.indexWhere((v) => v.verse == widget.initialVerse);
                  if (index != -1) {
                    _scrollController.animateTo(
                      index * 60.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return VerseListItem(
                    verse: verse,
                    isHighlighted: verse.verse == widget.initialVerse,
                  );
                },
              );
            } else {
              return const Center(child: Text('No verses found.'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class VerseListItem extends StatelessWidget {
  final Verse verse;
  final bool isHighlighted;

  const VerseListItem({
    super.key,
    required this.verse,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isHighlighted ? Colors.yellow[200] : null,
      child: ListTile(
        leading: Text('${verse.verse}'),
        title: Text(verse.passage),
      ),
    );
  }
}
