import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofco_app/_helper/page.dart';
import 'package:sofco_app/model/order_model.dart';
import 'package:sofco_app/view/detail_page/add_order_item.dart';
import 'package:sofco_app/viewmodel/order_vm.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class CreateOrderPage extends StatefulWidget {
  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  var orderId;
  var orderDate;

  @override
  void initState() {
    super.initState();
    OrderVM.orderItem.clear();
    orderId = DateFormat("dd/MM/yyyy #hh:mm:ss").format(DateTime.now());
    orderDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  }

  createOrder() {
    List<dynamic> orderItems = [];

    OrderVM.orderItem.forEach((item) {
      orderItems.add({
        "productName": item["productName"],
        "qty": item["qty"],
        "price": item["price"],
        "photo": item["photo"],
      });
    });

    var newOrder = Order(
      orderId: orderId,
      orderDate: DateTime.now(),
      orderItems: orderItems,
    );

    OrderVM.create(newOrder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Order"),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 150.0,
              height: 50.0,
              child: RaisedButton(
                color: Colors.orange[400],
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.qrcode),
                    Container(
                      width: 10.0,
                    ),
                    Text(
                      "Add Item",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  String photoScanResult = await scanner.scan();

                  var arr = photoScanResult.split(";");
                  var productName = arr[0];
                  var price = arr[1];
                  var photo = arr[2];

                  await Page.show(
                    context,
                    AddOrderItemPage(
                      productName: productName,
                      price: price,
                      photo: photo,
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  color: Colors.green[400],
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => createOrder(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Order ID: $orderId"),
                Spacer(),
                Text("Order Date: $orderDate"),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: OrderVM.orderItem.length,
                itemBuilder: (context, index) {
                  var orderItem = OrderVM.orderItem[index];

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
                      // Center(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child:
                      //         Text("${orderItem["qty"] * orderItem["price"]}"),
                      //   ),
                      // ),
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
