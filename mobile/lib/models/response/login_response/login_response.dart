// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final int? statusCode;
  final String? message;
  final LoginData? data;

  const LoginResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'LoginResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginResponse copyWith({
    int? statusCode,
    String? message,
    LoginData? data,
  }) {
    return LoginResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LoginResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ data.hashCode;
}

@JsonSerializable()
class LoginData {
  final String? accessToken;
  final User? user;

  const LoginData({
    this.accessToken,
    this.user,
  });

  @override
  String toString() {
    return 'LoginData(accessToken: $accessToken, user: $user)';
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return _$LoginDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);

  LoginData copyWith({
    String? accessToken,
    User? user,
  }) {
    return LoginData(
      accessToken: accessToken ?? this.accessToken,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LoginData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => accessToken.hashCode ^ user.hashCode;
}
