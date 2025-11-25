import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      AppConstants.login,
      data: FormData.fromMap({
        'email': email,
        'password': password,
        'mob_user': '1',
      }),
    );
    if (response.data['status'] == true) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(AppConstants.keyToken, response.data['access_token']);
    }
    return LoginResponse.fromJson(response.data);
  }
}
