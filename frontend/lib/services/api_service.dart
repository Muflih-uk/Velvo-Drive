import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = "https://velvo-drive.onrender.com/api/";
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchVehicles() async{
    try {
      final response = await _dio.get("$_baseUrl/vehicles/available");
      return response.data;
    } on DioException catch(e) {
      throw Exception('Failed to load posts: ${e.message}');
    } catch(e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  

}