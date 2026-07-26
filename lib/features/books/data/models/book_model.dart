class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnailUrl;
  final double rating;
  final double price;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnailUrl,
    required this.rating,
    this.price = 0.0,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
    final saleInfo = json['saleInfo'] as Map<String, dynamic>?;

    final retailPrice = saleInfo?['retailPrice'] as Map<String, dynamic>?;
    final listPrice = saleInfo?['listPrice'] as Map<String, dynamic>?;

    final double parsedPrice =
        (retailPrice?['amount'] as num?)?.toDouble() ??
        (listPrice?['amount'] as num?)?.toDouble() ??
        0.0;

    final rawRating = (volumeInfo['averageRating'] as num?)?.toDouble();
    final double parsedRating =
        (rawRating != null && rawRating > 0.0) ? rawRating : 4.5;

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
      rating: parsedRating,
      price: parsedPrice,
    );
  }
}
