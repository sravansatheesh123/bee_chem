class ApiaryRole {
  final int id;
  final String role;

  ApiaryRole({required this.id, required this.role});

  factory ApiaryRole.fromJson(Map<String, dynamic> json) {
    return ApiaryRole(
      id: json['id'],
      role: json['role'] ?? '',
    );
  }
}
