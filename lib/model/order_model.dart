class Order {
  String orderId;
  DateTime orderDate;
  List<dynamic> orderItems;
  String orderStatus;

  Order({
    this.orderId,
    this.orderDate,
    this.orderItems,
    this.orderStatus,
  });
}
