// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final int? statusCode;
  final String? message;
  final RegisterData? data;

  const RegisterResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'RegisterResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return _$RegisterResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  RegisterResponse copyWith({
    int? statusCode,
    String? message,
    RegisterData? data,
  }) {
    return RegisterResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RegisterResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ data.hashCode;
}

@JsonSerializable()
class RegisterData {
  final String? accessToken;
  final User? user;

  const RegisterData({
    this.accessToken,
    this.user,
  });

  @override
  String toString() {
    return 'RegisterData(accessToken: $accessToken, user: $user)';
  }

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return _$RegisterDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);

  RegisterData copyWith({
    String? accessToken,
    User? user,
  }) {
    return RegisterData(
      accessToken: accessToken ?? this.accessToken,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RegisterData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => accessToken.hashCode ^ user.hashCode;
}

@JsonSerializable()
class PatientProfile {
  final int? id;
  final String? address;
  final String? phone;
  final String? birthday;
  final String? gender;
  final String? identityNumber;
  final String? bloodType;
  final double? heightCm;
  final double? weightKg;
  final String? occupation;
  final String? lifestyleNotes;
  final String? insuranceNumber;
  final bool? consentForAIAnalysis;

  const PatientProfile({
    this.id,
    this.address,
    this.phone,
    this.birthday,
    this.gender,
    this.identityNumber,
    this.bloodType,
    this.heightCm,
    this.weightKg,
    this.occupation,
    this.lifestyleNotes,
    this.insuranceNumber,
    this.consentForAIAnalysis,
  });

  @override
  String toString() {
    return 'PatientProfile(id: $id, address: $address, phone: $phone, birthday: $birthday, gender: $gender, identityNumber: $identityNumber, bloodType: $bloodType, heightCm: $heightCm, weightKg: $weightKg, occupation: $occupation, lifestyleNotes: $lifestyleNotes, insuranceNumber: $insuranceNumber, consentForAIAnalysis: $consentForAIAnalysis)';
  }

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return _$PatientProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PatientProfileToJson(this);

  PatientProfile copyWith({
    int? id,
    String? address,
    String? phone,
    String? birthday,
    String? gender,
    String? identityNumber,
    String? bloodType,
    double? heightCm,
    double? weightKg,
    String? occupation,
    String? lifestyleNotes,
    String? insuranceNumber,
    bool? consentForAIAnalysis,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      identityNumber: identityNumber ?? this.identityNumber,
      bloodType: bloodType ?? this.bloodType,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      occupation: occupation ?? this.occupation,
      lifestyleNotes: lifestyleNotes ?? this.lifestyleNotes,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      consentForAIAnalysis: consentForAIAnalysis ?? this.consentForAIAnalysis,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PatientProfile) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      birthday.hashCode ^
      gender.hashCode ^
      identityNumber.hashCode ^
      bloodType.hashCode ^
      heightCm.hashCode ^
      weightKg.hashCode ^
      occupation.hashCode ^
      lifestyleNotes.hashCode ^
      insuranceNumber.hashCode ^
      consentForAIAnalysis.hashCode;
}
