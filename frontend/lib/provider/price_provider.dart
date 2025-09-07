import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  int _numOfItem = 1;
  int get numOfItem => _numOfItem;

  double _priceAfterDiscount;
  double get priceAfterDiscount => _priceAfterDiscount;

  ProductProvider(this._priceAfterDiscount);

  double get totalPrice => _numOfItem * _priceAfterDiscount;

  void increment() {
    _numOfItem++;
    notifyListeners();
  }

  void decrement() {
    if (_numOfItem > 1) {
      _numOfItem--;
      notifyListeners();
    }
  }
}
