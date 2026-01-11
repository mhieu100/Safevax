// lib/modules/reminder/reminder_controller.dart
import 'package:flutter_getx_boilerplate/shared/services/vaccination_history.dart';
import 'package:flutter_getx_boilerplate/shared/services/vaccination_service.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/reminder_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';

class ReminderController extends BaseController<ReminderRepository> {
  ReminderController(super.repository);
  final VaccinationService _vaccinationService = VaccinationService();

  final RxList<VaccinationHistory> _reminderHistory =
      <VaccinationHistory>[].obs;
  final RxList<VaccineBooking> _upcomingReminders = <VaccineBooking>[].obs;
  final Rx<VaccinationHistory?> _nextReminder = Rx<VaccinationHistory?>(null);
  final RxBool _isLoading = false.obs;

  List<VaccinationHistory> get reminderHistory => _reminderHistory;
  List<VaccineBooking> get upcomingReminders => _upcomingReminders;
  VaccinationHistory? get nextReminder => _nextReminder.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadReminderData();
  }

  Future<void> loadReminderData() async {
    _isLoading.value = true;
    try {
      // Load dữ liệu từ API hoặc local
      await Future.wait([
        _loadReminderHistory(),
        _loadUpcomingReminders(),
        _loadNextReminder(),
      ]);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu nhắc lịch');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadReminderHistory() async {
    try {
      // TODO: Implement API call
      final history =
          await _vaccinationService.getVaccinationHistory('user_id');
      _reminderHistory.assignAll(history);
    } catch (e) {
      print('Error loading reminder history: $e');
      _reminderHistory.assignAll([]);
    }
  }

  Future<void> _loadUpcomingReminders() async {
    try {
      // TODO: Implement API call
      final upcoming =
          await _vaccinationService.getUpcomingVaccinations('user_id');
      _upcomingReminders.assignAll(upcoming);
    } catch (e) {
      print('Error loading upcoming reminders: $e');
      _upcomingReminders.assignAll([]);
    }
  }

  Future<void> _loadNextReminder() async {
    try {
      // TODO: Implement API call
      final next = await _vaccinationService.getNextVaccination('user_id');
      _nextReminder.value = next;
    } catch (e) {
      print('Error loading next reminder: $e');
      _nextReminder.value = null;
    }
  }

  Future<bool> confirmReminderCompletion({
    required String reminderId,
    required String nurseId,
    String? notes,
  }) async {
    try {
      _isLoading.value = true;

      // TODO: Implement API call to confirm reminder
      final success = await _vaccinationService.confirmVaccination(
        vaccinationId: reminderId,
        nurseId: nurseId,
        notes: notes,
      );

      if (success) {
        // Update local state
        final index =
            _reminderHistory.indexWhere((hist) => hist.id == reminderId);
        if (index != -1) {
          final updatedHistory = _reminderHistory[index];
          _reminderHistory[index] = VaccinationHistory(
            id: updatedHistory.id,
            userId: updatedHistory.userId,
            vaccine: updatedHistory.vaccine,
            doseNumber: updatedHistory.doseNumber,
            vaccinationDate: updatedHistory.vaccinationDate,
            facility: updatedHistory.facility,
            status: 'completed',
            nurseId: nurseId,
            notes: notes,
            createdAt: updatedHistory.createdAt,
            updatedAt: DateTime.now(),
          );
        }

        Get.snackbar('Thành công', 'Đã xác nhận hoàn thành mũi tiêm');
        return true;
      } else {
        Get.snackbar('Lỗi', 'Không thể xác nhận mũi tiêm');
        return false;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xác nhận mũi tiêm: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> rescheduleReminder({
    required String reminderId,
    required DateTime newDate,
  }) async {
    try {
      _isLoading.value = true;

      // TODO: Implement API call to reschedule
      final success = await _vaccinationService.rescheduleVaccination(
        vaccinationId: reminderId,
        newDate: newDate,
      );

      if (success) {
        Get.snackbar('Thành công', 'Đã đổi lịch tiêm thành công');
        await loadReminderData(); // Reload data
      } else {
        Get.snackbar('Lỗi', 'Không thể đổi lịch tiêm');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể đổi lịch tiêm: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Method to simulate data for testing
  void loadMockData() {
    // Mock data for testing
    _reminderHistory.assignAll([
      VaccinationHistory(
        id: 'hist_1',
        userId: 'user_1',
        vaccine: VaccineModel(
          id: 'vac_1',
          name: 'Vaccine Pfizer',
          manufacturer: 'Pfizer',
          description: '',
          prevention: ['COVID-19'],
          numberOfDoses: 2,
          recommendedAge: '12+',
          price: 850000,
          imageUrl: '',
          sideEffects: [],
          schedule: [],
          doseIntervals: [],
        ),
        doseNumber: 1,
        vaccinationDate: DateTime.now().subtract(const Duration(days: 30)),
        facility: HealthcareFacility(
          id: 'fac_1',
          name: 'Bệnh viện Vinmec',
          address: '458 Minh Khai, Hà Nội',
          phone: '024 3974 3556',
          hours: '7:30 - 17:00',
          rating: 4.8,
          distance: 2.5,
          image: '',
          capacity: 100,
        ),
        status: 'completed',
        nurseId: 'nurse_001',
        notes: 'Tiêm thành công, không có phản ứng phụ',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ]);

    _nextReminder.value = VaccinationHistory(
      id: 'hist_2',
      userId: 'user_1',
      vaccine: VaccineModel(
        id: 'vac_1',
        name: 'Vaccine Pfizer',
        manufacturer: 'Pfizer',
        description: '',
        prevention: ['COVID-19'],
        numberOfDoses: 2,
        recommendedAge: '12+',
        price: 850000,
        imageUrl: '',
        sideEffects: [],
        schedule: [],
        doseIntervals: [],
      ),
      doseNumber: 2,
      vaccinationDate: DateTime.now().add(const Duration(days: 7)),
      facility: HealthcareFacility(
        id: 'fac_1',
        name: 'Bệnh viện Vinmec',
        address: '458 Minh Khai, Hà Nội',
        phone: '024 3974 3556',
        hours: '7:30 - 17:00',
        rating: 4.8,
        distance: 2.5,
        image: '',
        capacity: 100,
      ),
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
      updatedAt: DateTime.now(),
    );
  }
}
