class BookingHistoryGroupedResponse {
  final int statusCode;
  final String message;
  final List<GroupedBookingData> data;

  BookingHistoryGroupedResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BookingHistoryGroupedResponse.fromJson(Map<String, dynamic> json) {
    return BookingHistoryGroupedResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) =>
              GroupedBookingData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GroupedBookingData {
  final String routeId;
  final String vaccineName;
  final String vaccineSlug;
  final String patientName;
  final int requiredDoses;
  final int cycleIndex;
  final String createdAt;
  final int totalAmount;
  final String status;
  final int completedCount;
  final List<GroupedAppointmentData> appointments;
  final bool family;

  GroupedBookingData({
    required this.routeId,
    required this.vaccineName,
    required this.vaccineSlug,
    required this.patientName,
    required this.requiredDoses,
    required this.cycleIndex,
    required this.createdAt,
    required this.totalAmount,
    required this.status,
    required this.completedCount,
    required this.appointments,
    required this.family,
  });

  factory GroupedBookingData.fromJson(Map<String, dynamic> json) {
    return GroupedBookingData(
      routeId: json['routeId'] as String,
      vaccineName: json['vaccineName'] as String,
      vaccineSlug: json['vaccineSlug'] as String,
      patientName: json['patientName'] as String,
      requiredDoses: json['requiredDoses'] as int,
      cycleIndex: json['cycleIndex'] as int,
      createdAt: json['createdAt'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      status: json['status'] as String,
      completedCount: json['completedCount'] as int,
      appointments: (json['appointments'] as List<dynamic>)
          .map((item) =>
              GroupedAppointmentData.fromJson(item as Map<String, dynamic>))
          .toList(),
      family: json['family'] as bool,
    );
  }
}

class GroupedAppointmentData {
  final int id;
  final int doseNumber;
  final String scheduledDate;
  final String scheduledTimeSlot;
  final String? actualScheduledTime;
  final String? desiredDate;
  final String? desiredTimeSlot;
  final String? rescheduledAt;
  final String appointmentStatus;
  final int? patientId;
  final String patientName;
  final String patientPhone;
  final String? cashierName;
  final String? doctorName;
  final String vaccineName;
  final String vaccineSlug;
  final int centerId;
  final String centerName;
  final int paymentId;
  final String paymentStatus;
  final String paymentMethod;
  final int paymentAmount;
  final int? familyMemberId;
  final String vaccinationCourseId;
  final int vaccineTotalDoses;
  final String createdAt;

  GroupedAppointmentData({
    required this.id,
    required this.doseNumber,
    required this.scheduledDate,
    required this.scheduledTimeSlot,
    this.actualScheduledTime,
    this.desiredDate,
    this.desiredTimeSlot,
    this.rescheduledAt,
    required this.appointmentStatus,
    this.patientId,
    required this.patientName,
    required this.patientPhone,
    this.cashierName,
    this.doctorName,
    required this.vaccineName,
    required this.vaccineSlug,
    required this.centerId,
    required this.centerName,
    required this.paymentId,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.paymentAmount,
    this.familyMemberId,
    required this.vaccinationCourseId,
    required this.vaccineTotalDoses,
    required this.createdAt,
  });

  factory GroupedAppointmentData.fromJson(Map<String, dynamic> json) {
    return GroupedAppointmentData(
      id: json['id'] as int,
      doseNumber: json['doseNumber'] as int,
      scheduledDate: json['scheduledDate'] as String,
      scheduledTimeSlot: json['scheduledTimeSlot'] as String,
      actualScheduledTime: json['actualScheduledTime'] as String?,
      desiredDate: json['desiredDate'] as String?,
      desiredTimeSlot: json['desiredTimeSlot'] as String?,
      rescheduledAt: json['rescheduledAt'] as String?,
      appointmentStatus: json['appointmentStatus'] as String,
      patientId: json['patientId'] as int? ?? 0, // Handle null patientId
      patientName: json['patientName'] as String,
      patientPhone: json['patientPhone'] as String,
      cashierName: json['cashierName'] as String?,
      doctorName: json['doctorName'] as String?,
      vaccineName: json['vaccineName'] as String,
      vaccineSlug: json['vaccineSlug'] as String,
      centerId: json['centerId'] as int,
      centerName: json['centerName'] as String,
      paymentId: json['paymentId'] as int,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentAmount: (json['paymentAmount'] as num).toInt(),
      familyMemberId: json['familyMemberId'] as int?,
      vaccinationCourseId:
          json['vaccinationCourseId'].toString(), // Handle both int and string
      vaccineTotalDoses: json['vaccineTotalDoses'] as int,
      createdAt: json['createdAt'] as String,
    );
  }
}
