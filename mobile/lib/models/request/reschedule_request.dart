class RescheduleRequest {
  final int appointmentId;
  final String desiredDate;
  final String desiredTimeSlot;
  final String reason;

  RescheduleRequest({
    required this.appointmentId,
    required this.desiredDate,
    required this.desiredTimeSlot,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'desiredDate': desiredDate,
      'desiredTimeSlot': desiredTimeSlot,
      'reason': reason,
    };
  }
}
