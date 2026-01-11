// lib/models/vietnam_address.dart
class VietnamProvince {
  final String code;
  final String name;
  final String codeName;
  final String divisionType;
  final String phoneCode;

  VietnamProvince({
    required this.code,
    required this.name,
    required this.codeName,
    required this.divisionType,
    required this.phoneCode,
  });

  factory VietnamProvince.fromJson(Map<String, dynamic> json) {
    return VietnamProvince(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      codeName: json['codename']?.toString() ?? '',
      divisionType: json['division_type']?.toString() ?? '',
      phoneCode: json['phone_code']?.toString() ?? '',
    );
  }
}

class VietnamDistrict {
  final String code;
  final String name;
  final String codeName;
  final String divisionType;
  final String provinceCode;

  VietnamDistrict({
    required this.code,
    required this.name,
    required this.codeName,
    required this.divisionType,
    required this.provinceCode,
  });

  factory VietnamDistrict.fromJson(Map<String, dynamic> json) {
    return VietnamDistrict(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      codeName: json['codename']?.toString() ?? '',
      divisionType: json['division_type']?.toString() ?? '',
      provinceCode: json['province_code']?.toString() ?? '',
    );
  }
}

class VietnamWard {
  final String code;
  final String name;
  final String codeName;
  final String divisionType;
  final String districtCode;

  VietnamWard({
    required this.code,
    required this.name,
    required this.codeName,
    required this.divisionType,
    required this.districtCode,
  });

  factory VietnamWard.fromJson(Map<String, dynamic> json) {
    return VietnamWard(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      codeName: json['codename']?.toString() ?? '',
      divisionType: json['division_type']?.toString() ?? '',
      districtCode: json['district_code']?.toString() ?? '',
    );
  }
}