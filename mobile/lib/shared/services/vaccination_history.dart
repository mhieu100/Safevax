// lib/models/vaccination_history_model.dart
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';

class VaccinationHistory {
  final String id;
  final String userId;
  final VaccineModel vaccine;
  final int doseNumber;
  final DateTime vaccinationDate;
  final HealthcareFacility facility;
  final String status; // 'pending', 'completed', 'cancelled'
  final String? nurseId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaccinationHistory({
    required this.id,
    required this.userId,
    required this.vaccine,
    required this.doseNumber,
    required this.vaccinationDate,
    required this.facility,
    required this.status,
    this.nurseId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VaccinationHistory.fromDoseBooking({
    required DoseBooking doseBooking,
    required VaccineModel vaccine,
    required String userId,
    required int doseNumber,
  }) {
    return VaccinationHistory(
      id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      vaccine: vaccine,
      doseNumber: doseNumber,
      vaccinationDate: doseBooking.dateTime,
      facility: doseBooking.facility,
      status: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}