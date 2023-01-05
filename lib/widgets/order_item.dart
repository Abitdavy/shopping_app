import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:real_shopping_app/provider/orders.dart' as ord;
import 'dart:math';

import 'package:real_shopping_app/provider/products_provider.dart';
import 'package:real_shopping_app/widgets/cart_item.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItems order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    //final orderItems = Provider.of<OrderItem>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20 + 180, 300) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? min(widget.order.products.length * 20 + 10, 100) : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${e.quantity}x \$${e.price}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      // (e) => Card(
                      //   elevation: 5,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       ListTile(
                      //         leading: CircleAvatar(
                      //           radius: 50,
                      //           backgroundImage: NetworkImage(
                      //             e.imageUrl,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    )
                    .toList(),
              ),
            ),
            // Other Approach
            // Card(
            //   elevation: 2,
            //   color: Colors.white70,
            //   margin: EdgeInsets.only(top: 4),
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(color: Colors.white70, width: 1),
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(10),
            //       topRight: Radius.circular(10),
            //       bottomLeft: Radius.circular(20),
            //       bottomRight: Radius.circular(20),
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: ListTile(
            //           leading: CircleAvatar(
            //             backgroundColor:
            //                 Theme.of(context).colorScheme.secondary,
            //             radius: 30,
            //             backgroundImage: NetworkImage(
            //               widget.order.products,
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
