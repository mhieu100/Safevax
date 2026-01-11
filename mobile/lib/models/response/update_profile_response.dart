import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';

part 'update_profile_response.g.dart';

@JsonSerializable()
class UpdateProfileResponse {
  final int? statusCode;
  final String? message;
  final User? data;

  const UpdateProfileResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileResponseToJson(this);
}
