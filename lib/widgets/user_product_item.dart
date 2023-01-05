import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/products_provider.dart';
import 'package:real_shopping_app/screens/edit_products_screen.dart';
import 'package:real_shopping_app/screens/update_product.dart';

class UserItems extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  UserItems(
    this.id,
    this.title,
    this.imageUrl,
    this.description,
  );

  @override
  Widget build(BuildContext context) {
    final errorScaffod = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductsScreen.routeName, arguments: id);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProducts(id);
              } catch (error) {
                errorScaffod.showSnackBar(
                  SnackBar(
                    content: Text('Delete Failed'),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
