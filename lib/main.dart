import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/helpers/custom_route.dart';
import './provider/auth.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './provider/products_provider.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/splashScreen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previous) => ProductsProvider(
              auth.token, previous == null ? [] : previous.items, auth.userId),
          create: (_) => ProductsProvider('', [], ''),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (ctx, auth, previous) => Order(
              auth.token, auth.userId, previous == null ? [] : previous.orders),
          create: (context) => Order('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop Hamba',
          theme: ThemeData(
            fontFamily: 'Lato',
            primaryColor: Colors.green,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android : CustomRoutePageTransitionBuilder(),
            })
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : AuthScreen(),
                  future: auth.autoLogin(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            cartScreen.routeName: (context) => cartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            userProductsScreen.routeName: (context) => userProductsScreen(),
            EditProductsScreen.routeName: (context) => EditProductsScreen(),
            //UpdateProduct.routeName:(context) => UpdateProduct(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductOverviewScreen();
  }
}
