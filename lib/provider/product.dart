import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue){
    isFavourite = newValue;
    notifyListeners();
  }

  void toogleFavoriteStatus(String? token, String? userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        'https://grandshoponline-315dc-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: jsonEncode(
          {
            'isFavorite': isFavourite,
          },
        ),
      );
      if(response.statusCode >= 400){
        _setFavValue(oldStatus);
      };
    } catch (error) {
      _setFavValue(oldStatus);
      throw error;
    }
  }
}
