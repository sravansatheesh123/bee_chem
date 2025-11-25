import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/personnel.dart';
import '../models/role.dart';

class PersonnelService {

  final Dio _dio = ApiClient.instance.dio;

  Future<List<Personnel>> getPersonnelList() async {

    await ApiClient.instance.addAuthHeader();

    final res = await _dio.get(
      AppConstants.personnelList,
      options: Options(
        headers: {
          "Accept": "application/json",
        },
      ),
    );

    print("LIST RESPONSE = ${res.data}");
    if (res.data['status'] == true) {
      final List data = res.data['data'] ?? [];
      return data.map((e) => Personnel.fromJson(e)).toList();
    }
    return [];
  }


  Future<List<ApiaryRole>> getRoles() async {
    await ApiClient.instance.addAuthHeader();

    final res = await _dio.get(AppConstants.apiaryRoles);

    print("ROLES RESPONSE = ${res.data}");

    if (res.data is List) {
      return (res.data as List).map((e) => ApiaryRole.fromJson(e)).toList();
    }
    return [];
  }


  Future<String> addPersonnel({
    required String firstName,
    required String address,
    required String latitude,
    required String longitude,
    required String suburb,
    required String state,
    required String postcode,
    required String country,
    required String contactNumber,
    required int roleId,
    required bool isActive,
  }) async {

    await ApiClient.instance.addAuthHeader();

    final formData = FormData.fromMap({
      'first_name': firstName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'suburb': suburb,
      'state': state,
      'postcode': postcode,
      'country': country,
      'contact_number': contactNumber,
      'role_ids': roleId.toString(),
      'status': isActive ? '1' : '0',
    });

    final res = await _dio.post(AppConstants.addPersonnel, data: formData);

    print("📥 ADD RESPONSE = ${res.data}");

    if (res.data['status'] == true) {
      return res.data['message'] ?? 'Saved successfully';
    }

    return res.data['message'] ?? "Something went wrong";
  }
}
