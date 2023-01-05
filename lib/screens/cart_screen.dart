import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:real_shopping_app/provider/orders.dart';
import 'package:real_shopping_app/widgets/cart_item.dart';

class cartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItemList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart, cartItemList: cartItemList),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemBuilder: (context, index) => CartItems(
                cartItemList[index].id,
                cart.items.keys.toList()[index],
                cartItemList[index].title,
                cartItemList[index].price,
                cartItemList[index].quantity,
                cartItemList[index].imageUrl,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.cartItemList,
  }) : super(key: key);

  final Cart cart;
  final List<CartItem> cartItemList;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                widget.cartItemList,
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text(
        'ORDER NOW',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
