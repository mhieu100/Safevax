import 'package:json_annotation/json_annotation.dart';

part 'complete_profile_request.g.dart';

@JsonSerializable()
class CompleteProfileRequest {
  final String phone;
  final String address;
  final String birthday;
  final String gender;
  final String identityNumber;
  final String bloodType;
  final String heightCm;
  final String weightKg;
  final String? occupation;
  final String? lifestyleNotes;
  final String? insuranceNumber;

  const CompleteProfileRequest({
    required this.phone,
    required this.address,
    required this.birthday,
    required this.gender,
    required this.identityNumber,
    required this.bloodType,
    required this.heightCm,
    required this.weightKg,
    this.occupation,
    this.lifestyleNotes,
    this.insuranceNumber,
  });

  factory CompleteProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteProfileRequestToJson(this);
}
