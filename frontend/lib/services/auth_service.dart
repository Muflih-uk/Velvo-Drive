

import 'package:dio/dio.dart';

class AuthService {

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://velvo-drive.onrender.com/api/")
  );

  Future<String> register(
    String username,
    String email,
    String password
  ) async{
    try{
      final response = await _dio.post(
        'auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password
        }
      );
      return response.data.toString();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('auth/login', 
      data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  void _handleError(DioException e) {
     final errorMessage = e.response?.data['error'] ?? 'An unknown error occurred';
     throw Exception(errorMessage);
  }
}