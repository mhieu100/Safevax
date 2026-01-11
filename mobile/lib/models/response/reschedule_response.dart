class RescheduleResponse {
  final int appointmentId;
  final String oldDate;
  final String oldTimeSlot;
  final String newDate;
  final String newTimeSlot;
  final String status;
  final String message;

  RescheduleResponse({
    required this.appointmentId,
    required this.oldDate,
    required this.oldTimeSlot,
    required this.newDate,
    required this.newTimeSlot,
    required this.status,
    required this.message,
  });

  factory RescheduleResponse.fromJson(Map<String, dynamic> json) {
    return RescheduleResponse(
      appointmentId: json['appointmentId'],
      oldDate: json['oldDate'],
      oldTimeSlot: json['oldTimeSlot'],
      newDate: json['newDate'],
      newTimeSlot: json['newTimeSlot'],
      status: json['status'],
      message: json['message'],
    );
  }
}
