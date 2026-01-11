import 'dart:convert';

class BookingRequest {
  final String userId;
  final List<String> vaccineIds;
  final Map<String, int> vaccineQuantities;
  final DateTime bookingDate;
  final Map<int, DoseBookingRequest> doseBookings;
  final String? paymentMethod;

  BookingRequest({
    required this.userId,
    required this.vaccineIds,
    required this.vaccineQuantities,
    required this.bookingDate,
    required this.doseBookings,
    this.paymentMethod,
  });

  factory BookingRequest.fromRawJson(String str) =>
      BookingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
        userId: json["userId"],
        vaccineIds: List<String>.from(json["vaccineIds"].map((x) => x)),
        vaccineQuantities: Map.from(json["vaccineQuantities"])
            .map((k, v) => MapEntry<String, int>(k, v)),
        bookingDate: DateTime.parse(json["bookingDate"]),
        doseBookings: Map.from(json["doseBookings"]).map((k, v) =>
            MapEntry<int, DoseBookingRequest>(
                int.parse(k), DoseBookingRequest.fromJson(v))),
        paymentMethod: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "vaccineIds": List<dynamic>.from(vaccineIds.map((x) => x)),
        "vaccineQuantities": vaccineQuantities,
        "bookingDate": bookingDate.toIso8601String(),
        "doseBookings": Map.from(doseBookings)
            .map((k, v) => MapEntry<String, dynamic>(k.toString(), v.toJson())),
        "paymentMethod": paymentMethod,
      };
}

class DoseBookingRequest {
  final int doseNumber;
  final DateTime dateTime;
  final String facilityId;
  final String vaccineId;
  final int vaccineDoseNumber;

  DoseBookingRequest({
    required this.doseNumber,
    required this.dateTime,
    required this.facilityId,
    required this.vaccineId,
    required this.vaccineDoseNumber,
  });

  factory DoseBookingRequest.fromJson(Map<String, dynamic> json) =>
      DoseBookingRequest(
        doseNumber: json["doseNumber"],
        dateTime: DateTime.parse(json["dateTime"]),
        facilityId: json["facilityId"],
        vaccineId: json["vaccineId"],
        vaccineDoseNumber: json["vaccineDoseNumber"],
      );

  Map<String, dynamic> toJson() => {
        "doseNumber": doseNumber,
        "dateTime": dateTime.toIso8601String(),
        "facilityId": facilityId,
        "vaccineId": vaccineId,
        "vaccineDoseNumber": vaccineDoseNumber,
      };
}
