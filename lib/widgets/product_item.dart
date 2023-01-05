import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/auth.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:real_shopping_app/provider/product.dart';
import 'package:real_shopping_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) {
              return IconButton(
                onPressed: () {
                  product.toogleFavoriteStatus(authData.token, authData.userId);
                },
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(
                  product.id, product.title, product.price, product.imageUrl);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added Item to the Cart!',
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.undoSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
