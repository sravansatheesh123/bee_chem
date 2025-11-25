class Personnel {
  final int id;
  final String firstName;
  final String? lastName;
  final String address;
  final String suburb;
  final String state;
  final String postcode;
  final String country;
  final String contactNumber;
  final String latitude;
  final String longitude;
  final int status;

  final List<dynamic> roleIds;
  final List<dynamic> apiaryRoleArray;
  final String roleName;

  Personnel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.address,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.country,
    required this.contactNumber,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.roleIds,
    required this.apiaryRoleArray,
    required this.roleName,
  });

  String get fullName =>
      (lastName == null || lastName!.isEmpty)
          ? firstName
          : '$firstName $lastName';

  String get fullAddress =>
      '$address, $suburb, $state, $postcode, $country';

  bool get isActive => status == 1;

  factory Personnel.fromJson(Map<String, dynamic> json) {

    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    List<dynamic> normalize(dynamic value) {
      if (value == null) return [];
      if (value is List) return value;
      if (value is String) return [value];
      return [];
    }

    String extractedRole = "";
    if (json['role_details'] is List && json['role_details'].isNotEmpty) {
      extractedRole = json['role_details'][0]['role'] ?? "";
    }

    return Personnel(
      id: safeInt(json['id']),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      address: json['address'] ?? '',
      suburb: json['suburb'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode']?.toString() ?? '',
      country: json['country'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      status: safeInt(json['status']),
      roleIds: normalize(json['role_ids']),
      apiaryRoleArray: normalize(json['apiary_role_array']),
      roleName: extractedRole,
    );
  }
}
