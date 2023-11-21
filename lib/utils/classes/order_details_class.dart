class OrderDetails {
  final String storeEmail;
  final String orderId;
  final String userEmail;
  final String menuItemId;
  final int itemCount;

  OrderDetails({
    required this.storeEmail,
    required this.orderId,
    required this.userEmail,
    required this.menuItemId,
    required this.itemCount,
  });
}
