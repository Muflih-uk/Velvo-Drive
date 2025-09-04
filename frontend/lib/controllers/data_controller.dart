import 'package:shop/services/api_service.dart';

class DataController {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchVehicles() async {
    return _apiService.fetchVehicles();
  }
}