class AuthorEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String jobTitle;
  final String about;
  final int rating;

  const AuthorEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.jobTitle,
    required this.about,
    required this.rating,
  });
}
