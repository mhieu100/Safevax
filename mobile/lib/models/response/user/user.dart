// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/response/register_response/register_response.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? avatar;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? birthday;
  final String? gender;
  final String? address;
  final String? identityNumber;
  final String? bloodType;
  final double? heightCm;
  final double? weightKg;
  final String? occupation;
  final String? lifestyleNotes;
  final String? insuranceNumber;
  final bool? consentForAIAnalysis;
  final String? role;
  final bool? isActive;
  final PatientProfile? patientProfile;

  const User({
    this.id,
    this.avatar,
    this.fullName,
    this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.address,
    this.identityNumber,
    this.bloodType,
    this.heightCm,
    this.weightKg,
    this.occupation,
    this.lifestyleNotes,
    this.insuranceNumber,
    this.consentForAIAnalysis,
    this.role,
    this.isActive,
    this.patientProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? avatar,
    String? fullName,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? address,
    String? identityNumber,
    String? bloodType,
    double? heightCm,
    double? weightKg,
    String? occupation,
    String? lifestyleNotes,
    String? insuranceNumber,
    bool? consentForAIAnalysis,
    String? role,
    bool? isActive,
    PatientProfile? patientProfile,
  }) {
    return User(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      identityNumber: identityNumber ?? this.identityNumber,
      bloodType: bloodType ?? this.bloodType,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      occupation: occupation ?? this.occupation,
      lifestyleNotes: lifestyleNotes ?? this.lifestyleNotes,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      consentForAIAnalysis: consentForAIAnalysis ?? this.consentForAIAnalysis,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      patientProfile: patientProfile ?? this.patientProfile,
    );
  }

  List<Object?> get props {
    return [
      id,
      avatar,
      fullName,
      email,
      phone,
      birthday,
      gender,
      address,
      identityNumber,
      bloodType,
      heightCm,
      weightKg,
      occupation,
      lifestyleNotes,
      insuranceNumber,
      consentForAIAnalysis,
      role,
      isActive,
      patientProfile,
    ];
  }
}
