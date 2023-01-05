import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/products_provider.dart';
import 'package:real_shopping_app/screens/edit_products_screen.dart';
import 'package:real_shopping_app/widgets/app_drawer.dart';
import 'package:real_shopping_app/widgets/user_product_item.dart';

class userProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context);
    print('Rebuilding Widget...');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              Card(
                                elevation: 5,
                                child: UserItems(
                                  productData.items[index].id,
                                  productData.items[index].title,
                                  productData.items[index].imageUrl,
                                  productData.items[index].description,
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
