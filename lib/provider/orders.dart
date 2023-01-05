import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  final String? authToken;
  final String? userId;

  Order(this.authToken, this.userId, this._orders);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'price': e.price,
                  'quantity': e.quantity,
                  'image Url':e.imageUrl,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItems(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItems> loadedOrders = [];
    if(extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderID, orderData) {
      loadedOrders.add(OrderItems(
        id: orderID,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (e) => CartItem(
                id: e['id'],
                title: e['title'],
                quantity: e['quantity'],
                price: e['price'],
                imageUrl: e['image Url'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
