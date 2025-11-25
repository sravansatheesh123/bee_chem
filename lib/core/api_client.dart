import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Dio get dio => _dio;

  Future<void> addAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyToken) ?? "";

    _dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    print("HEADERS SET = ${_dio.options.headers}");
  }
}
