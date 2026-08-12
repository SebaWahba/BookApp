class CartItemEntity {
  final String id;
  final String title;
  final double price;
  final String thumbnailUrl;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnailUrl,
    required this.quantity,
  });
}