import 'package:flutter/material.dart';
import 'package:shop/controllers/data_controller.dart';

class DataProvider with ChangeNotifier {
  DataProvider(this._dataController);

  final DataController _dataController;


  bool _isLoading = false;
  List<dynamic> _data = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<dynamic> get data => _data;
  String? get error => _error;

  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _data = await _dataController.fetchVehicles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}