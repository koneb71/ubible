import 'package:flutter/material.dart';
import 'package:ubible/models/book.dart';
import 'package:ubible/search/search_delegate.dart';
import 'package:ubible/utils/database_helper.dart';
import 'chapter_list_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.select('select * from book_list_content');
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bible Books'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BibleSearchDelegate(),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Book>>(
          future: _books,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final books = snapshot.data!;
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChapterListScreen(book: book.name),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text('No books found.'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
