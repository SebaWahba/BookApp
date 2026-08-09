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

    final idStr = json['id'] as String? ?? '';
    final apiPrice =
        (retailPrice?['amount'] as num?)?.toDouble() ??
        (listPrice?['amount'] as num?)?.toDouble();

    final double parsedPrice;
    if (apiPrice != null && apiPrice > 0.0) {
      parsedPrice = apiPrice;
    } else {
      // Dynamic price per book based on ID hash so every book has its own distinct price
      final hash = idStr.hashCode.abs();
      final defaultPrices = [
        12.99,
        14.99,
        18.99,
        22.50,
        25.00,
        29.99,
        34.50,
        39.99,
        45.00,
      ];
      parsedPrice = defaultPrices[hash % defaultPrices.length];
    }

    final rawRating = (volumeInfo['averageRating'] as num?)?.toDouble();
    final double parsedRating = (rawRating != null && rawRating > 0.0)
        ? rawRating
        : 4.5;

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

  factory BookModel.fromFavoriteJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'No Title Available',
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          ['Unknown Author'],
      description:
          json['description'] as String? ?? 'No description provided.',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFavoriteJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'rating': rating,
      'price': price,
    };
  }
}
