import 'package:json_annotation/json_annotation.dart';

part 'complete_profile_response.g.dart';

@JsonSerializable()
class CompleteProfileResponse {
  final int? statusCode;
  final String? message;
  final CompleteProfileData? data;

  const CompleteProfileResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteProfileResponseToJson(this);
}

@JsonSerializable()
class CompleteProfileData {
  final int id;
  final String? avatar;
  final String fullName;
  final String email;
  final String phone;
  final String birthday;
  final String gender;
  final String address;
  final String identityNumber;
  final String bloodType;
  final double heightCm;
  final double weightKg;
  final bool consentForAIAnalysis;
  final String role;
  final bool isActive;

  const CompleteProfileData({
    required this.id,
    this.avatar,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.identityNumber,
    required this.bloodType,
    required this.heightCm,
    required this.weightKg,
    required this.consentForAIAnalysis,
    required this.role,
    required this.isActive,
  });

  factory CompleteProfileData.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteProfileDataToJson(this);
}
