import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';

part 'account_response.g.dart';

@JsonSerializable()
class AccountResponse {
  final int? statusCode;
  final String? message;
  final User? data;

  const AccountResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);
}
