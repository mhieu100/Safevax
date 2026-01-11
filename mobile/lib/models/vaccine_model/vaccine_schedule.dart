// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'vaccine_schedule.g.dart';

enum ScheduleStatus {
  @JsonValue('SCHEDULED')
  scheduled,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

@JsonSerializable()
class VaccineSchedule {
  final int? id;
  final int? userId;
  final int? vaccineId;
  final int? doseNumber;
  final String? scheduledDate;
  final String? scheduledTime;
  final ScheduleStatus? status;
  final String? timeInterval;

  const VaccineSchedule({
    this.id,
    this.userId,
    this.vaccineId,
    this.doseNumber,
    this.scheduledDate,
    this.scheduledTime,
    this.status,
    this.timeInterval,
  });

  int getDaysInterval() => int.tryParse(timeInterval ?? '') ?? 0;

  String get timeIntervalNonNull => timeInterval ?? '';

  factory VaccineSchedule.fromJson(Map<String, dynamic> json) {
    return _$VaccineScheduleFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VaccineScheduleToJson(this);

  VaccineSchedule copyWith({
    int? id,
    int? userId,
    int? vaccineId,
    int? doseNumber,
    String? scheduledDate,
    String? scheduledTime,
    ScheduleStatus? status,
    String? timeInterval,
  }) {
    return VaccineSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vaccineId: vaccineId ?? this.vaccineId,
      doseNumber: doseNumber ?? this.doseNumber,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      timeInterval: timeInterval ?? this.timeInterval,
    );
  }
}
