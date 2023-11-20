class Order {
  final String storeEmail;
  final String orderId;
  final String userEmail;
  final int orderStatus;
  final String orderNote;
  final String orderCreatingTime;
  final int itemCount;
  final int orderTotalPrice;

  Order({
    required this.storeEmail,
    required this.orderId,
    required this.userEmail,
    required this.orderStatus,
    required this.orderNote,
    required this.orderCreatingTime,
    required this.itemCount,
    required this.orderTotalPrice,
  });
}
