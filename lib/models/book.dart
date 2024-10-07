class Book {
  final int id;
  final String name;

  Book({required this.id, required this.name});

  factory Book.fromMap(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
    );
  }
}
