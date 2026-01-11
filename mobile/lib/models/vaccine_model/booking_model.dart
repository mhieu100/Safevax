// lib/modules/vaccine_booking/vaccine_booking_model.dart
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';

class VaccineBooking {
  final String id;
  final String userId;
  final String? familyMemberId;
  final List<VaccineModel> vaccines;
  final Map<String, int> vaccineQuantities; // Add this field
  final DateTime bookingDate;
  final Map<int, DoseBooking>
      doseBookings; // Key: dose number, Value: dose booking info
  final double totalPrice;
  final String status; // pending, confirmed, completed, cancelled
  final String? paymentMethod;
  final String? confirmationCode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final HealthcareFacility? vaccineFacility;

  VaccineBooking({
    required this.id,
    required this.userId,
    this.familyMemberId,
    required this.vaccines,
    required this.vaccineQuantities, // Add this parameter
    required this.bookingDate,
    required this.doseBookings,
    required this.totalPrice,
    this.status = 'pending',
    this.paymentMethod,
    this.confirmationCode,
    required this.createdAt,
    this.updatedAt,
    this.vaccineFacility,
  });

  VaccineBooking copyWith({
    String? id,
    String? userId,
    String? familyMemberId,
    List<VaccineModel>? vaccines,
    Map<String, int>? vaccineQuantities,
    DateTime? bookingDate,
    Map<int, DoseBooking>? doseBookings,
    double? totalPrice,
    String? status,
    String? paymentMethod,
    String? confirmationCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    HealthcareFacility? vaccineFacility,
  }) {
    return VaccineBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      vaccines: vaccines ?? this.vaccines,
      vaccineQuantities: vaccineQuantities ?? this.vaccineQuantities,
      bookingDate: bookingDate ?? this.bookingDate,
      doseBookings: doseBookings ?? this.doseBookings,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vaccineFacility: vaccineFacility ?? this.vaccineFacility,
    );
  }

  // Get facility for a specific dose
  HealthcareFacility? getFacilityForDose(int doseNumber) {
    return doseBookings[doseNumber]?.facility;
  }

  // Get date for a specific dose
  DateTime? getDateForDose(int doseNumber) {
    return doseBookings[doseNumber]?.dateTime;
  }

  // Check if all doses are at the same facility
  bool get isSameFacilityForAllDoses {
    if (doseBookings.isEmpty) return true;

    final firstFacility = doseBookings.values.first.facility;
    return doseBookings.values
        .every((dose) => dose.facility.id == firstFacility.id);
  }

  // Get list of all unique facilities used in this booking
  List<HealthcareFacility> get allFacilities {
    return doseBookings.values.map((dose) => dose.facility).toSet().toList();
  }

  factory VaccineBooking.fromJson(Map<String, dynamic> json) {
    final doseBookingsMap = <int, DoseBooking>{};
    if (json['doseBookings'] is Map) {
      (json['doseBookings'] as Map).forEach((key, value) {
        final doseNumber = int.tryParse(key.toString());
        if (doseNumber != null && value is Map<String, dynamic>) {
          doseBookingsMap[doseNumber] = DoseBooking.fromJson(value);
        }
      });
    }

    // Parse vaccine quantities
    final vaccineQuantitiesMap = <String, int>{};
    if (json['vaccineQuantities'] is Map) {
      (json['vaccineQuantities'] as Map).forEach((key, value) {
        if (key is String && value is int) {
          vaccineQuantitiesMap[key] = value;
        }
      });
    }

    return VaccineBooking(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      familyMemberId: json['familyMemberId']?.toString(),
      vaccines: (json['vaccines'] as List<dynamic>?)?.map((item) {
            return VaccineModel.fromJson(item);
          }).toList() ??
          [],
      vaccineQuantities: vaccineQuantitiesMap, // Add this
      bookingDate:
          DateTime.parse(json['bookingDate'] ?? DateTime.now().toString()),
      doseBookings: doseBookingsMap,
      totalPrice:
          (json['totalPrice'] is num ? json['totalPrice'].toDouble() : 0.0),
      status: json['status']?.toString() ?? 'pending',
      paymentMethod: json['paymentMethod']?.toString(),
      confirmationCode: json['confirmationCode']?.toString(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final doseBookingsJson = <String, dynamic>{};
    doseBookings.forEach((doseNumber, doseBooking) {
      doseBookingsJson[doseNumber.toString()] = doseBooking.toJson();
    });

    return {
      'id': id,
      'userId': userId,
      'familyMemberId': familyMemberId,
      'vaccines': vaccines.map((vaccine) => vaccine.toJson()).toList(),
      'vaccineQuantities': vaccineQuantities, // Add this
      'bookingDate': bookingDate.toIso8601String(),
      'doseBookings': doseBookingsJson,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'confirmationCode': confirmationCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class DoseBooking {
  final int doseNumber;
  DateTime dateTime;
  final HealthcareFacility facility;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
  final String vaccineId; // Add this field
  final int vaccineDoseNumber; // Add this field

  DoseBooking({
    required this.doseNumber,
    required this.dateTime,
    required this.facility,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    required this.vaccineId, // Add this parameter
    required this.vaccineDoseNumber, // Add this parameter
  });

  factory DoseBooking.fromJson(Map<String, dynamic> json) {
    return DoseBooking(
      doseNumber: json['doseNumber'] is int ? json['doseNumber'] : 0,
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toString()),
      facility: HealthcareFacility.fromJson(json['facility'] ?? {}),
      isCompleted: json['isCompleted'] == true,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      notes: json['notes']?.toString(),
      vaccineId: json['vaccineId']?.toString() ?? '', // Add this
      vaccineDoseNumber: json['vaccineDoseNumber'] is int
          ? json['vaccineDoseNumber']
          : 1, // Add this
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doseNumber': doseNumber,
      'dateTime': dateTime.toIso8601String(),
      'facility': facility.toJson(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
      'vaccineId': vaccineId, // Add this
      'vaccineDoseNumber': vaccineDoseNumber, // Add this
    };
  }
}

// Helper class to create new bookings
class VaccineBookingBuilder {
  final String userId;
  final String? familyMemberId;
  final List<VaccineModel> vaccines;
  final Map<String, int> vaccineQuantities; // Add this
  final DateTime firstDoseDate;
  final HealthcareFacility firstDoseFacility;
  final Map<int, HealthcareFacility> doseFacilities;
  final String? paymentMethod;

  VaccineBookingBuilder({
    required this.userId,
    this.familyMemberId,
    required this.vaccines,
    required this.vaccineQuantities, // Add this
    required this.firstDoseDate,
    required this.firstDoseFacility,
    this.doseFacilities = const {},
    this.paymentMethod,
  });

  VaccineBooking build() {
    final doseBookings = <int, DoseBooking>{};
    final totalDoses = vaccines.fold<int>(0, (sum, vaccine) {
      final quantity = vaccineQuantities[vaccine.id] ?? 1;
      return sum + (vaccine.numberOfDoses * quantity);
    });

    DateTime currentDate = firstDoseDate;

    for (int doseNumber = 1; doseNumber <= totalDoses; doseNumber++) {
      // Get facility for this dose (use specific facility if provided, otherwise use first dose facility)
      final facility = doseFacilities[doseNumber] ?? firstDoseFacility;

      doseBookings[doseNumber] = DoseBooking(
        doseNumber: doseNumber,
        dateTime: currentDate,
        facility: facility,
        vaccineId: _getVaccineIdForDose(doseNumber), // Add this
        vaccineDoseNumber: _getVaccineDoseNumber(doseNumber), // Add this
      );

      // Calculate next dose date based on vaccine schedule
      if (doseNumber < totalDoses) {
        final daysToNextDose = _getDaysToNextDose(doseNumber);
        currentDate = currentDate.add(Duration(days: daysToNextDose));
      }
    }

    final totalPrice = _calculateTotalPrice();
    final confirmationCode = 'VAC-${DateTime.now().millisecondsSinceEpoch}';

    return VaccineBooking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      familyMemberId: familyMemberId,
      vaccines: vaccines,
      vaccineQuantities: vaccineQuantities, // Add this
      bookingDate: DateTime.now(),
      doseBookings: doseBookings,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
      confirmationCode: confirmationCode,
      createdAt: DateTime.now(),
    );
  }

  String _getVaccineIdForDose(int doseNumber) {
    // This is a simplified implementation
    // You might need more complex logic to determine which vaccine this dose belongs to
    if (vaccines.isNotEmpty) {
      return vaccines.first.id;
    }
    return '';
  }

  int _getVaccineDoseNumber(int doseNumber) {
    // This is a simplified implementation
    // You might need more complex logic to determine the dose number within the vaccine
    return 1;
  }

  int _getDaysToNextDose(int currentDose) {
    // For simplicity, use the schedule from the first vaccine
    // In a real app, you might need more complex logic for multiple vaccines
    if (vaccines.isNotEmpty && vaccines.first.schedule.length > currentDose) {
      return vaccines.first.schedule[currentDose].getDaysInterval();
    }
    return 28; // Default interval
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var vaccine in vaccines) {
      final quantity = vaccineQuantities[vaccine.id] ?? 1;
      total += vaccine.price * vaccine.numberOfDoses * quantity;
    }
    return total;
  }
}

// Add this class to your BookingVaccinesController file
class DoseScheduling {
  final int doseNumber;
  final VaccineModel vaccine;
  final int vaccineDoseNumber;
  final DateTime dateTime;
  final HealthcareFacility facility;

  DoseScheduling({
    required this.doseNumber,
    required this.vaccine,
    required this.vaccineDoseNumber,
    required this.dateTime,
    required this.facility,
  });

  DoseScheduling copyWith({
    DateTime? dateTime,
    HealthcareFacility? facility,
  }) {
    return DoseScheduling(
      doseNumber: doseNumber,
      vaccine: vaccine,
      vaccineDoseNumber: vaccineDoseNumber,
      dateTime: dateTime ?? this.dateTime,
      facility: facility ?? this.facility,
    );
  }
}
