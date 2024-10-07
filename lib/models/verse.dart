class Verse {
  final int id;
  final String book;
  final int chapter;
  final int verse;
  final String passage;

  Verse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.passage,
  });

  factory Verse.fromMap(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      book: json['book'] is String ? json['book'] : json['book'].toString(),
      chapter:
          json['chapter'] is int ? json['chapter'] : int.parse(json['chapter']),
      verse: json['verse'] is int ? json['verse'] : int.parse(json['verse']),
      passage: json['passage'] ?? '',
    );
  }
}
