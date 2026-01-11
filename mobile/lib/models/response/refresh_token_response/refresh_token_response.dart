// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/response/login_response/login_response.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  final int? statusCode;
  final String? message;
  final LoginData? data;

  const RefreshTokenResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'RefreshTokenResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return _$RefreshTokenResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);

  RefreshTokenResponse copyWith({
    int? statusCode,
    String? message,
    LoginData? data,
  }) {
    return RefreshTokenResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RefreshTokenResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ data.hashCode;
}
