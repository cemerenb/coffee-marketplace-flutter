class OrderDetails {
  final String storeEmail;
  final String orderId;
  final String userEmail;
  final String menuItemId;
  final int itemCount;
  final int itemCanceled;
  final String cancelNote;

  OrderDetails({
    required this.storeEmail,
    required this.orderId,
    required this.userEmail,
    required this.menuItemId,
    required this.itemCount,
    required this.itemCanceled,
    required this.cancelNote,
  });
}
