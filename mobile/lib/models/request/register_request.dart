import 'dart:convert';

class RegisterRequest {
  RegisterRequest({
    required this.user,
    required this.patientProfile,
  });

  UserData user;
  PatientProfileData patientProfile;

  factory RegisterRequest.fromRawJson(String str) =>
      RegisterRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        user: UserData.fromJson(json["user"]),
        patientProfile: PatientProfileData.fromJson(json["patientProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "fullName": user.fullName,
        "email": user.email,
        "password": user.password,
        // Note: patientProfile data might need to be handled separately or the API might not support it
      };
}

class UserData {
  UserData({
    required this.fullName,
    required this.email,
    required this.password,
  });

  String fullName;
  String email;
  String password;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        fullName: json["fullName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
      };
}

class PatientProfileData {
  PatientProfileData({
    required this.address,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.identityNumber,
    required this.bloodType,
    required this.heightCm,
    required this.weightKg,
  });

  String address;
  String phone;
  String birthday;
  String gender;
  String identityNumber;
  String bloodType;
  int heightCm;
  int weightKg;

  factory PatientProfileData.fromJson(Map<String, dynamic> json) =>
      PatientProfileData(
        address: json["address"],
        phone: json["phone"],
        birthday: json["birthday"],
        gender: json["gender"],
        identityNumber: json["identityNumber"],
        bloodType: json["bloodType"],
        heightCm: json["heightCm"],
        weightKg: json["weightKg"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "phone": phone,
        "birthday": birthday,
        "gender": gender,
        "identityNumber": identityNumber,
        "bloodType": bloodType,
        "heightCm": heightCm,
        "weightKg": weightKg,
      };
}
