class OrderEntity {
  final String id;
  final String title;
  final String status;
  final int itemsCount;
  final String imageUrl;
  final String dateGroup;

  const OrderEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.itemsCount,
    required this.imageUrl,
    required this.dateGroup,
  });
}