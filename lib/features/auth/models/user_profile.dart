class UserProfile {
  final String firstName;
  final String lastName;
  final String documentType;
  final String documentNumber;
  final String email;
  final String phone;
  final String country;
  final String department;
  final String city;
  final String address;
  final List<String> roles;
  final bool isActive;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.country,
    required this.department,
    required this.city,
    required this.address,
    required this.roles,
    required this.isActive,
  });

  // Nombre completo para el AppBar, el Drawer y el encabezado del perfil
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Usuario' : name;
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? documentType,
    String? documentNumber,
    String? email,
    String? phone,
    String? country,
    String? department,
    String? city,
    String? address,
    List<String>? roles,
    bool? isActive,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      department: department ?? this.department,
      city: city ?? this.city,
      address: address ?? this.address,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }
}
