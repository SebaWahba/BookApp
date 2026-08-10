import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory AuthorModel.fromMap(String id, Map<String, dynamic> json) {
    return AuthorModel(
      id: id,
      name: json['name'] as String? ?? 'Unknown Author',
      imageUrl: json['imageUrl'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? 'Author',
      about: json['about'] as String? ?? 'No biography available.',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }

  factory AuthorModel.fromJson(String id, Map<String, dynamic> json) {
    return AuthorModel.fromMap(id, json);
  }

  factory AuthorModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AuthorModel.fromMap(doc.id, data);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'jobTitle': jobTitle,
      'about': about,
      'rating': rating,
    };
  }
}