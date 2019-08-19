import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sofco_app/_helper/page.dart';
import 'package:sofco_app/model/order_model.dart';
import 'package:sofco_app/view/detail_page/view_order_detail.dart';

class OrderVM {
  static List<Map<String, dynamic>> orderItem = [];

  static Future create(Order newOrder) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      await Firestore.instance.collection('order').document().setData({
        "orderId": newOrder.orderId,
        "orderDate": DateFormat("dd-MM-yyyy hh:mm:ss")
            .format(newOrder.orderDate)
            .toString(),
        "orderStatus": "New Order",
        "orderItems": newOrder.orderItems,
      });
    });
  }

  static Future loadOrderByOrderId(context, String orderId) async {
    var querySnapshot = await Firestore.instance
        .collection("order")
        .where("orderId", isEqualTo: orderId)
        .getDocuments();

    var document = querySnapshot.documents.first;
    Page.show(
      context,
      ViewOrderDetailPage(
        document: document,
      ),
    );
  }
}
