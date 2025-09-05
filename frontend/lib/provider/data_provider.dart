import 'package:flutter/material.dart';
import 'package:shop/controllers/data_controller.dart';

class DataProvider with ChangeNotifier {
  DataProvider(this._dataController);

  final DataController _dataController;

  Map<String, dynamic> _user = {};

  bool _isLoading = false;
  List<dynamic> _data = [];
  String? _error;

  Map<String, dynamic> get user => _user;
  bool get isLoading => _isLoading;
  List<dynamic> get data => _data;
  String? get error => _error;


  Future<void> fetchUserDetail() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _user = await _dataController.fetchUserDetails();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchVehicle() async {
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

  Future<void> fetchFlashSale() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _data = await _dataController.fetchFlashSale();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularVehicle() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _data = await _dataController.fetchPopularVehicle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserVehicle() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _data = await _dataController.fetchUserVehicle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkedVehicle() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 
    try {
      _data = await _dataController.fetchBookmarkedVehicle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}