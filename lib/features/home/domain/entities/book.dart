class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnail;
  final double? averageRating;
  final String? description;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.averageRating,
    this.description,
  });
}