import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:real_shopping_app/widgets/dialog_helper.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItems(this.id, this.productId, this.title, this.price, this.quantity,
      this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (DismissDirection direction) {
        return DialogHelper.showDecisionDialog(context);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(title),
            subtitle: Text('Total : \$${price * quantity}'),
            trailing: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 0) {
                        Provider.of<Cart>(context, listen: false)
                            .addOrRemoveItem(productId, false);
                      }
                    },
                    icon: Icon(
                      Icons.remove,
                      color: Colors.black,
                    ),
                  ),
                  Text('${quantity}x'),
                  IconButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addOrRemoveItem(productId, true);
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
