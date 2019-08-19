import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofco_app/viewmodel/order_vm.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewOrderDetailPage extends StatefulWidget {
  final DocumentSnapshot document;

  ViewOrderDetailPage({
    @required this.document,
  });

  @override
  _ViewOrderDetailPageState createState() => _ViewOrderDetailPageState();
}

class _ViewOrderDetailPageState extends State<ViewOrderDetailPage> {
  @override
  void initState() {
    super.initState();
    OrderVM.orderItem.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Order"),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            "Cancel Order",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Firestore.instance
                .collection("order")
                .document(widget.document.documentID)
                .updateData({"orderStatus": "Canceled"});

            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Order ID: ${widget.document["orderId"]}"),
            Text("Order Date: ${widget.document["orderDate"]}"),
            QrImage(
              data: widget.document["orderId"],
              size: 200.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.document["orderItems"].length,
                itemBuilder: (context, index) {
                  var orderItem = widget.document["orderItems"][index];

                  return Card(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          leading: Image.network(orderItem["photo"]),
                          title: Text("${orderItem["productName"]}"),
                          subtitle: Row(
                            children: <Widget>[
                              Text("${orderItem["qty"]}"),
                              Text(" X "),
                              Text("${orderItem["price"]}"),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${orderItem["qty"] * orderItem["price"]}",
                          ),
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
