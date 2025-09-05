import 'package:dio/dio.dart';
import 'package:shop/services/api_service.dart';

class DataController {
  final ApiService _apiService = ApiService();

  // Fetch full Vehicle 
  Future<List<dynamic>> fetchVehicles() async {
    try {
      final Response response = await _apiService.dio.get('vehicles/available');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }

  // fetch User Details
  Future<Map<String, dynamic>> fetchUserDetails() async {
    try {
      final Response response = await _apiService.dio.get('users/me');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch User Details: $e");
      return {};
    }
  }

  // fetch flash Sale
  Future<List<dynamic>> fetchFlashSale() async {
    try {
      final Response response = await _apiService.dio.get('featured/flash-sales');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }

  // fetch popular Vehicle
  Future<List<dynamic>> fetchPopularVehicle() async {
    try {
      final Response response = await _apiService.dio.get('featured/popular');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }

  // fetch flash Sale
  Future<List<dynamic>> fetchUserVehicle() async {
    try {
      final Response response = await _apiService.dio.get('users/me/vehicles');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }

  // Show the Bookmark
  Future<List<dynamic>> fetchBookmarkedVehicle() async {
    try {
      final Response response = await _apiService.dio.get('users/me/bookmarks');
      return response.data;
    } on DioException catch(e) {
      print("Get Error in Fetch Vehicle: $e");
      return [];
    }
  }
}