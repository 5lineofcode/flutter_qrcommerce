import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofco_app/_helper/page.dart';
import 'package:sofco_app/view/detail_page/create_order.dart';
import 'package:sofco_app/view/detail_page/view_order_detail.dart';
import 'package:sofco_app/viewmodel/order_vm.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  var streamBuilder = StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('order').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Text('Loading...');
        default:
          return ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return InkWell(
                onTap: () {
                  if (document["orderStatus"] == "Canceled") return;

                  Page.show(
                    context,
                    ViewOrderDetailPage(
                      document: document,
                    ),
                  );
                },
                child: Card(
                  color: document["orderStatus"] == "Canceled"
                      ? Colors.red[100]
                      : Colors.grey[100],
                  child: ListTile(
                    title: Text(document['orderId']),
                    subtitle: Text(document['orderStatus'].toString()),
                  ),
                ),
              );
            }).toList(),
          );
      }
    },
  );

  String scannedQrCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order List"),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              String scannedOrderId = await scanner.scan();
              OrderVM.loadOrderByOrderId(context, scannedOrderId);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.qrcode),
                  Container(
                    width: 10.0,
                  ),
                  Text("Scan Order")
                ],
              ),
            ),
          ),
        ],
      ),
      body: streamBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Page.show(context, CreateOrderPage()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
