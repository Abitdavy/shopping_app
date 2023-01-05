import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/orders.dart';
import 'package:real_shopping_app/widgets/app_drawer.dart';
import 'package:real_shopping_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('building ORders...');
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              //error thorwback
              return const Center(
                child: Text('error'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (context, index) => OrderItem(
                    orderData.orders[index],
                  ),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
