// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_schedule.dart';

part 'create_schedule_response.g.dart';

@JsonSerializable()
class CreateScheduleResponse {
  final int? statusCode;
  final String? message;
  final List<VaccineSchedule>? data;

  const CreateScheduleResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'CreateScheduleResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  factory CreateScheduleResponse.fromJson(Map<String, dynamic> json) {
    return _$CreateScheduleResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreateScheduleResponseToJson(this);

  CreateScheduleResponse copyWith({
    int? statusCode,
    String? message,
    List<VaccineSchedule>? data,
  }) {
    return CreateScheduleResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CreateScheduleResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ data.hashCode;
}
