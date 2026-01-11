import 'package:flutter_getx_boilerplate/models/family_member.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/services/services.dart';
import 'package:get/get.dart';

class NavigatorHelper {
  static toOnBoardScreen() {
    return Get.offNamed(Routes.onboard);
  }

  static toAuth() {
    StorageService.clear();
    return Get.offNamed(Routes.auth);
  }

  static toLoginScreen() {
    StorageService.clear();
    return Get.offNamed(Routes.login);
  }

  static toRegisterScreen() {
    return Get.toNamed(Routes.register);
  }

  static toForgotPasswordScreen() {
    return Get.toNamed(Routes.forgotPassword);
  }

  static toVerificationCodeScreen() {
    return Get.toNamed(Routes.verification);
  }

  static toBottomNavigationScreen() {
    return Get.offAllNamed(Routes.bottomNav);
  }

  static toMedicalProfileScreen() {
    return Get.toNamed(Routes.medicalProfile);
  }

  static toEditProfileScreen() {
    return Get.toNamed(Routes.editProfile);
  }

  static toVaccineListScreen() {
    return Get.toNamed(Routes.vaccineList);
  }

  static toVaccineListDetailScreen() {
    return Get.toNamed(Routes.vaccineListDetail);
  }

  static toVaccineManagementScreen() {
    return Get.toNamed(Routes.vaccineManagement);
  }

  static toVaccinationHistoryScreen() {
    return Get.toNamed(Routes.vaccinationHistory);
  }

  static toVaccineMissingScreen() {
    return Get.toNamed(Routes.vaccineMissing);
  }

  static toVaccineDetailScreen() {
    return Get.toNamed(Routes.vaccineScheduleDetail);
  }

  static toMedicalAlertsScreen() {
    return Get.toNamed(Routes.medicalAlerts);
  }

  static toMedicalAlertsDetailScreen() {
    return Get.toNamed(Routes.medicalAlertsDetail);
  }

  static toMedicalNewsDetailScreen() {
    return Get.toNamed(Routes.medicalNewsDetail);
  }

  static toVaccineScheduleScreen({Map<String, dynamic>? arguments}) {
    return Get.toNamed(Routes.vaccineSchedule, arguments: arguments);
  }

  static toAppointmentListScreen() {
    return Get.toNamed(Routes.appointmentList);
  }

  static Future<HealthcareFacility?> toFacilitySelectionScreen() async {
    final result = await Get.toNamed(
      Routes.facilitySelection,
    );

    if (result is HealthcareFacility) {
      return result;
    }
    return null;
  }

  static Future<HealthcareFacility?> toFacilityMapScreen() async {
    final result = await Get.toNamed(
      Routes.facilityMap,
    );

    if (result is HealthcareFacility) {
      return result;
    }
    return null;
  }

  static toScheduleSelectionScreen() {
    return Get.toNamed(Routes.scheduleSelection);
  }

  static toReminderScreen() {
    return Get.toNamed(Routes.vaccinationHistory);
  }

  static toVaccineConsultationScreen() {
    return Get.toNamed(Routes.vaccineConsultation);
  }

  static toBookingVaccinesScreen({required bool useCartOverride}) {
    return Get.toNamed(
      Routes.bookingVaccines,
      arguments: {'useCartOverride': useCartOverride},
    );
  }

  static toBookingSummaryScreen({required VaccineBooking booking}) {
    return Get.toNamed(
      Routes.bookingSummary,
      arguments: {'booking': booking},
    );
  }

  static toPaymentSuccessScreen({required VaccineBooking booking}) {
    print(
        'NavigatorHelper: Navigating to PaymentSuccess with booking totalPrice: ${booking.totalPrice}');
    return Get.toNamed(
      Routes.paymentSuccess,
      arguments: booking, // Pass booking directly instead of wrapping in map
    );
  }

  static toProfileScreen() {
    return Get.toNamed(Routes.profile);
  }

  static toFamilyManagementScreen() {
    return Get.toNamed(Routes.familyManagement);
  }

  static toFamilyMemberDetailScreen(FamilyMember member) {
    return Get.toNamed(Routes.familyMemberDetail, arguments: member);
  }

  static toMedicalNewsScreen() {
    return Get.toNamed(Routes.medicalNews);
  }

  static toVaccinationCertificateScreen() {
    return Get.toNamed(Routes.vaccinationCertificate);
  }

  static toVaccinationCertificateScreenWithBooking(VaccineBooking booking) {
    return Get.toNamed(
      Routes.vaccinationCertificate,
      arguments: booking,
    );
  }

  static toCompleteProfileScreen() {
    return Get.toNamed(Routes.completeProfile);
  }
}
