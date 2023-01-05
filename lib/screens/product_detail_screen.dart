import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/product.dart';
import 'package:real_shopping_app/provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';

  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductsProvider>(context).findbyId(productId);
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: BackButton(
      //     color: Colors.black54,
      //   ),
      //   title: Text(
      //     loadedProduct.title,
      //     style: TextStyle(color: Theme.of(context).primaryColor),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: productId,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Container(
                    
                    child: Text(
                      '\$${loadedProduct.price}',
                      style: TextStyle(
                          fontSize: 25, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    '${loadedProduct.description}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 2000,
                ),
                Text('hello')
              ],
            ),
          )
        ],
      ),
    );
  }
}
