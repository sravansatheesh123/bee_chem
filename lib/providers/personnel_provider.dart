import 'package:flutter/material.dart';
import '../models/personnel.dart';
import '../models/role.dart';
import '../services/personnel_service.dart';

class PersonnelProvider extends ChangeNotifier {
  final PersonnelService _service = PersonnelService();

  List<Personnel> _all = [];
  List<Personnel> get all => _all;
  List<Personnel> filtered = [];
  bool isLoading = false;
  String? error;

  List<ApiaryRole> roles = [];
  bool rolesLoading = false;

  Future<void> fetchPersonnel() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final list = await _service.getPersonnelList();

    _all = list;
    filtered = List.from(list);
    error = null;

    isLoading = false;
    notifyListeners();
  }



  void filterByName(String query) {
    if (query.isEmpty) {
      filtered = List.from(_all);
    } else {
      filtered = _all
          .where((p) => p.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> loadRoles() async {
    rolesLoading = true;
    notifyListeners();

    try {
      roles = await _service.getRoles();
    } catch (e) {
      roles = [];
    }

    rolesLoading = false;
    notifyListeners();
  }

  Future<String?> addPersonnel({
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
    try {
      final msg = await _service.addPersonnel(
        firstName: firstName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        suburb: suburb,
        state: state,
        postcode: postcode,
        country: country,
        contactNumber: contactNumber,
        roleId: roleId,
        isActive: isActive,
      );

      await fetchPersonnel();
      return msg;
    } catch (e) {
      return "Something went wrong";
    }
  }
}
