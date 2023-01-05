import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:real_shopping_app/models/http_exception.dart';
import 'package:real_shopping_app/provider/product.dart';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  Product findbyId(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future addProduct(Product product) async {
    final url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'image Url': product.imageUrl,
          'isFavorite': product.isFavourite,
          'creatorId' : userId,
        }),
      );
      final newproduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      url = Uri.parse(
          'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponseData = await http.get(url);
      final favoriteData = json.decode(favoriteResponseData.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite:
              favoriteData == null ? false : favoriteData[prodId] == null ? false : favoriteData[prodId]['isFavorite'],
          imageUrl: prodData['image Url'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> UpdateProduct(String id, Product newproduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = newproduct;
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json$authToken');
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': newproduct.title,
              'description': newproduct.description,
              'price': newproduct.price,
              'image Url': newproduct.imageUrl,
            }));
      } catch (error) {
        throw error;
      }
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProducts(String id) async {
    final url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw httpException('could not delete product.');
    }
    existingProduct = null;
  }
}
