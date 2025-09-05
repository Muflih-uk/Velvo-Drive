import 'package:dio/dio.dart';
import 'package:shop/services/api_service.dart';

class DataController {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchVehicles() async {
    try {
      final Response response = await _apiService.dio.get('vehicles/available');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }

}