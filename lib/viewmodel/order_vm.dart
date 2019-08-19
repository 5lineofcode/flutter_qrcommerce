import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sofco_app/model/order_model.dart';

class OrderVM {
  static List<Map<String, dynamic>> orderItem = [];

  static Future create(Order newOrder) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      await Firestore.instance.collection('order').document().setData({
        "orderId": newOrder.orderId,
        "orderDate": newOrder.orderDate,
        "orderStatus": "New Order",
        "orderItems": newOrder.orderItems,
      });
    });
  }

  static Future<DocumentSnapshot> loadOrderByOrderId(String orderId) async {
    var querySnapshot = await Firestore.instance
        .collection("order")
        .where("orderId", isEqualTo: orderId)
        .getDocuments();

    var document = querySnapshot.documents.first;
    return Future.value(document);
  }
}
