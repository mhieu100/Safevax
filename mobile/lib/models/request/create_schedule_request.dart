class CreateScheduleRequest {
  final int vaccineId;
  final String selectedDate;
  final String selectedTime;

  CreateScheduleRequest({
    required this.vaccineId,
    required this.selectedDate,
    required this.selectedTime,
  });

  Map<String, dynamic> toJson() => {
        'vaccineId': vaccineId,
        'selectedDate': selectedDate,
        'selectedTime': selectedTime,
      };
}
