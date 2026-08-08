import '../../domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.jobTitle,
    required super.about,
    required super.rating,
  });

  factory AuthorModel.fromJson(String id, Map<String, dynamic> json) {
    return AuthorModel(
      id: id,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      about: json['about'] ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 4,
    );
  }
}
