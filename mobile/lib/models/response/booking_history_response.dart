class BookingHistoryResponse {
  final int statusCode;
  final String message;
  final List<BookingHistoryData> data;

  BookingHistoryResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BookingHistoryResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) =>
              BookingHistoryData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BookingHistoryData {
  final int bookingId;
  final int patientId;
  final String patientName;
  final int? familyMemberId;
  final String? familyMemberName;
  final String vaccineName;
  final double totalAmount;
  final int totalDoses;
  final String bookingStatus;
  final String createdAt;
  final List<AppointmentData> appointments;

  BookingHistoryData({
    required this.bookingId,
    required this.patientId,
    required this.patientName,
    this.familyMemberId,
    this.familyMemberName,
    required this.vaccineName,
    required this.totalAmount,
    required this.totalDoses,
    required this.bookingStatus,
    required this.createdAt,
    required this.appointments,
  });

  factory BookingHistoryData.fromJson(Map<String, dynamic> json) {
    return BookingHistoryData(
      bookingId: json['bookingId'] as int,
      patientId: json['patientId'] as int,
      patientName: json['patientName'] as String,
      familyMemberId: json['familyMemberId'] as int?,
      familyMemberName: json['familyMemberName'] as String?,
      vaccineName: json['vaccineName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalDoses: json['totalDoses'] as int,
      bookingStatus: json['bookingStatus'] as String,
      createdAt: json['createdAt'] as String,
      appointments: (json['appointments'] as List<dynamic>)
          .map((item) => AppointmentData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AppointmentData {
  final int appointmentId;
  final int doseNumber;
  final String scheduledDate;
  final String scheduledTime;
  final int centerId;
  final String centerName;
  final int? doctorId;
  final String? doctorName;
  final int? cashierId;
  final String? cashierName;
  final String appointmentStatus;

  AppointmentData({
    required this.appointmentId,
    required this.doseNumber,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.centerId,
    required this.centerName,
    this.doctorId,
    this.doctorName,
    this.cashierId,
    this.cashierName,
    required this.appointmentStatus,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointmentId: json['appointmentId'] as int,
      doseNumber: json['doseNumber'] as int,
      scheduledDate: json['scheduledDate'] as String,
      scheduledTime: json['scheduledTime'] as String,
      centerId: json['centerId'] as int,
      centerName: json['centerName'] as String,
      doctorId: json['doctorId'] as int?,
      doctorName: json['doctorName'] as String?,
      cashierId: json['cashierId'] as int?,
      cashierName: json['cashierName'] as String?,
      appointmentStatus: json['appointmentStatus'] as String,
    );
  }
}
