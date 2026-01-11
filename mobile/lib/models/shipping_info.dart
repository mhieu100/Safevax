class ShippingInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String streetAddress;
  final String city;
  final String? state;
  final String zipCode;

  ShippingInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.streetAddress,
    required this.city,
    this.state,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      zipCode: json['zipCode'] ?? '',
    );
  }

  ShippingInfo copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return ShippingInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}
