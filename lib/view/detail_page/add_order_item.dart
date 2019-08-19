import 'package:flutter/material.dart';
import 'package:sofco_app/viewmodel/order_vm.dart';

class AddOrderItemPage extends StatefulWidget {
  final String productName;
  final String price;
  final String photo;

  AddOrderItemPage({
    @required this.productName,
    @required this.price,
    @required this.photo,
  });

  @override
  _AddOrderItemPageState createState() => _AddOrderItemPageState();
}

class _AddOrderItemPageState extends State<AddOrderItemPage> {
  var qty = 0;

  addItem() {
    OrderVM.orderItem.add({
      "productName": widget.productName,
      "qty": qty,
      "price": double.parse(
          widget.price.replaceAll("\$", "").toString().split(".")[0].replaceAll(",", "")),
      "photo": widget.photo,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Order Item"),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          color: Colors.green[400],
          child: Text(
            "Add Item",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            addItem();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Image.network(
                widget.photo,
              ),
              Text(
                widget.productName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              Text(
                widget.price,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  RaisedButton(
                    child: Text(
                      "-",
                      style: TextStyle(
                        fontSize: 40.0,
                      ),
                    ),
                    onPressed: () {
                      if (qty == 0) return;
                      setState(() {
                        qty--;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$qty",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 40.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
