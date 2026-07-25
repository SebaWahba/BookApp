class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnailUrl;
  final double rating;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnailUrl,
    required this.rating,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    return BookModel(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'No Title Available',
      authors:
          (volumeInfo['authors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Unknown Author'],
      description:
          volumeInfo['description'] as String? ?? 'No description provided.',
      thumbnailUrl: (imageLinks?['thumbnail'] as String? ?? '').replaceFirst(
        'http://',
        'https://',
      ),
      rating: (volumeInfo['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
