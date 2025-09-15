import 'package:dio/dio.dart';
import 'package:shop/controllers/main_controller.dart';

class ApiService {

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://velvo-drive.onrender.com/api/', 
        connectTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 15000),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_AuthInterceptor());
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? token = await MainController.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('--> Authorization header added.');
    } else {
      print('--> No auth token found, proceeding without it.');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print('<<< ERROR! Unauthorized request. Maybe token expired?');
      // For example, you could clear the token and navigate to login
      // TokenManager.deleteToken();
      // navigatorKey.currentState?.pushReplacementNamed('/login');
    }
    // Continue with the error
    return handler.next(err);
  }
}
