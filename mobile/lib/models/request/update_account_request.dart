import 'package:json_annotation/json_annotation.dart';

part 'update_account_request.g.dart';

@JsonSerializable()
class UpdateAccountRequest {
  final String? avatar;
  final String fullName;
  final String email;
  final String phone;
  final String birthday;
  final String gender;
  final String identityNumber;
  final String bloodType;
  @JsonKey(includeIfNull: false)
  final int? heightCm;
  @JsonKey(includeIfNull: false)
  final int? weightKg;
  final String address;
  final String occupation;
  final String insuranceNumber;
  final String lifestyleNotes;

  const UpdateAccountRequest({
    this.avatar,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.identityNumber,
    required this.bloodType,
    this.heightCm,
    this.weightKg,
    required this.address,
    required this.occupation,
    required this.insuranceNumber,
    required this.lifestyleNotes,
  });

  factory UpdateAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccountRequestToJson(this);
}
