import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/cart.dart';
import 'package:real_shopping_app/provider/products_provider.dart';
import 'package:real_shopping_app/screens/cart_screen.dart';
import 'package:real_shopping_app/widgets/app_drawer.dart';
import 'package:real_shopping_app/widgets/badge.dart';
import 'package:real_shopping_app/widgets/product_item.dart';
import 'package:real_shopping_app/widgets/products_grid.dart';

enum FIlterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _dependChange = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_dependChange) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetData().then((value) {
        setState(() {
          _isLoading = false;
          print('fetching done');
        });
      });
    }
    _dependChange = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(cartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemCount.toString(),
            ),
            //child:
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FIlterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FIlterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (FIlterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FIlterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                },
              );
            },
          ),
        ],
        elevation: 0,
        title: const Text('Toko Genji'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.clear),
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          preferredSize: const Size.fromHeight(30),
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ProductsGrid(_showOnlyFavorites),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
