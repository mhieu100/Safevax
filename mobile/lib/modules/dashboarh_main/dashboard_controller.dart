// dashboard_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_detail/vaccine_detail_binding.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_detail/vaccine_detail_screen.dart';
import 'package:flutter_getx_boilerplate/repositories/dashboard_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_news_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:flutter_getx_boilerplate/models/response/featured_news_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:get/get.dart';

class DashboardController extends BaseController<DashboardRepository> {
  final MedicalNewsRepository newsRepository;

  DashboardController(super.repository, this.newsRepository);

  var userName = ''.obs;
  var avatar = ''.obs;
  var dosesTaken = '0'.obs;
  var appointmentCount = '0'.obs;
  var healthAlertsCount = '2'.obs; // This could be dynamic too if needed

  var newsItems = <NewsItem>[].obs;

  @override
  Future getData() async {
    print('DashboardController: getData called');
    // Load user data
    _loadUserData();

    // Only fetch dashboard data if we have a token
    if (StorageService.token == null) {
      print('DashboardController: No token available, skipping API call');
      // No token available, don't make API call
      return;
    }

    // Fetch booking data and featured news
    await _loadBookingStats();
    await _loadFeaturedNews();
  }

  Future<void> _loadFeaturedNews() async {
    print('DashboardController: Starting to load featured news');
    try {
      final response = await newsRepository.getFeaturedNews();
      print(
          'DashboardController: Received response with ${response.news.length} news items');
      newsItems.assignAll(response.news);
      print(
          'DashboardController: Assigned ${newsItems.length} items to newsItems');
    } catch (e) {
      print('DashboardController: Error loading featured news: $e');
      // On error, keep empty list or handle gracefully
      newsItems.clear();
    }
  }

  void _loadUserData() {
    final userData = StorageService.userData;
    if (userData != null) {
      final user = User.fromJson(userData);
      userName.value = user.fullName ?? '';
      avatar.value = user.avatar ?? '';
    }
  }

  // Method to refresh user data from storage
  void refreshUserData() {
    _loadUserData();
  }

  Future<void> _loadBookingStats() async {
    try {
      final response = await repository.getBookingHistoryGrouped();

      // Calculate total counts
      int totalVaccines = response.data.length;
      int totalAppointments = 0;

      for (final booking in response.data) {
        totalAppointments += booking.appointments.length;
      }

      dosesTaken.value = totalVaccines.toString();
      appointmentCount.value = totalAppointments.toString();
    } catch (e) {
      // Reset counts to 0 on error
      dosesTaken.value = '0';
      appointmentCount.value = '0';
    }
  }

  List<StatItem> get stats => [
        StatItem(dosesTaken.value, 'Mũi đã tiêm',
            Icons.medical_services_rounded, Color(0xFF4CAF50)),
        StatItem(appointmentCount.value, 'Lịch hẹn',
            Icons.calendar_month_rounded, Color(0xFF2196F3)),
        StatItem(healthAlertsCount.value, 'Cảnh báo', Icons.warning_rounded,
            Color(0xFFFF9800)),
      ];

  final quickActions = const [
    QuickActionItem(
      "Lịch của tôi",
      Icons.calendar_month_rounded,
      [Color(0xFF199A8E), Color(0xFF2AB7A9)],
    ),
    QuickActionItem(
      "AI Hỗ trợ",
      Icons.medical_services_rounded,
      [Color(0xFF2196F3), Color(0xFF21B0F3)],
    ),
    QuickActionItem(
      "Hồ sơ sức khỏe",
      Icons.health_and_safety_rounded,
      [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    ),
    QuickActionItem(
      "Khẩn cấp",
      Icons.emergency_rounded,
      [Color(0xFFFF5252), Color(0xFFFF6B6B)],
    ),
  ];

  final features = const [
    FeatureItem(Icons.medical_services_rounded, 'Vaccine', Color(0xFF4CAF50)),
    FeatureItem(Icons.calendar_month_rounded, 'Lịch tiêm', Color(0xFF199A8E)),
    FeatureItem(Icons.verified_rounded, 'Chứng nhận', Color(0xFF2196F3)),
    FeatureItem(Icons.group_rounded, 'Gia đình', Color(0xFF9C27B0)),
    FeatureItem(Icons.notifications_rounded, 'Cảnh báo', Color(0xFFFF9800)),
    FeatureItem(Icons.local_hospital_rounded, 'Bệnh viện', Color(0xFFF44336)),
    FeatureItem(Icons.chat_rounded, 'AI Hỗ trợ', Color(0xFF607D8B)),
    FeatureItem(Icons.article_rounded, 'Tin tức', Color(0xFF795548)),
  ];

  final alerts = const [
    AlertItem(
      "Cảnh báo dịch sốt xuất huyết",
      "Khu vực Hà Nội đang có dịch sốt xuất huyết bùng phát. Cần thực hiện các biện pháp phòng ngừa.",
      true,
      "2 giờ trước",
    ),
    AlertItem(
      "Cập nhật vaccine cúm mùa",
      "Đã có vaccine cúm mùa mới nhất 2023. Đề nghị người dân đến các cơ sở y tế để tiêm phòng.",
      false,
      "1 ngày trước",
    ),
  ];

  // Navigation methods
  void navigateToVaccinationSchedule() {
    NavigatorHelper.toVaccineManagementScreen();
  }

  void navigateToAIHelp() {
    NavigatorHelper.toVaccineConsultationScreen();
  }

  void navigateToHealthRecords() {
    // Navigate to edit profile screen
    NavigatorHelper.toEditProfileScreen();
  }

  void navigateToEmergency() {
    // Navigate to medical alerts screen for emergency information
    NavigatorHelper.toMedicalAlertsScreen();
  }

  void navigateToFeature(String featureName) {
    switch (featureName) {
      case 'Lịch tiêm':
        navigateToVaccinationSchedule();
        break;
      case 'Vaccine':
        NavigatorHelper.toVaccineListScreen();
        break;
      case 'Chứng nhận':
        // Navigate to vaccination certificate screen
        NavigatorHelper.toVaccinationCertificateScreen();
        break;
      case 'Gia đình':
        NavigatorHelper.toFamilyManagementScreen();
        break;
      case 'Cảnh báo':
        NavigatorHelper.toMedicalAlertsScreen();
        break;
      case 'Bệnh viện':
        // Navigate to facility map for hospital information
        NavigatorHelper.toFacilityMapScreen();
        break;
      case 'AI Hỗ trợ':
        navigateToAIHelp();
        break;
      case 'Tin tức':
        NavigatorHelper.toMedicalNewsScreen();
        break;
      default:
        // Show snackbar for unimplemented features
        Get.snackbar(
          'Thông báo',
          'Tính năng "$featureName" đang được phát triển',
          backgroundColor: const Color(0xFF199A8E),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
    }
  }

  void navigateToAlertDetails(int index) {
    // Navigate to medical alerts detail screen
    NavigatorHelper.toMedicalAlertsDetailScreen();
  }

  void navigateToNewsDetails(int index) {
    // Navigate to medical news detail screen with news item
    final newsItem = newsItems[index];
    Get.toNamed(Routes.medicalNewsDetail, arguments: newsItem.toJson());
  }

  void navigateToAllAlerts() {
    // Navigate to medical alerts screen to see all alerts
    NavigatorHelper.toMedicalAlertsScreen();
  }

  void navigateToAllNews() {
    // Navigate to medical news screen to see all news
    NavigatorHelper.toMedicalNewsScreen();
  }

  void navigateToProfile() {
    // Navigate to profile screen
    NavigatorHelper.toProfileScreen();
  }

  // Additional navigation methods for stat cards
  void navigateToStatDetails(String statType) {
    switch (statType) {
      case 'Mũi đã tiêm':
        // Navigate to vaccine management
        navigateToVaccinationSchedule();
        break;
      case 'Lịch hẹn':
        // Navigate to appointment list
        NavigatorHelper.toAppointmentListScreen();
        break;
      case 'Cảnh báo':
        // Navigate to medical alerts
        NavigatorHelper.toMedicalAlertsScreen();
        break;
      default:
        Get.snackbar(
          'Thông báo',
          'Chi tiết cho "$statType" đang được phát triển',
          backgroundColor: const Color(0xFF199A8E),
          colorText: Colors.white,
        );
    }
  }
}

class StatItem {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatItem(this.value, this.label, this.icon, this.color);
}

class QuickActionItem {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const QuickActionItem(this.title, this.icon, this.gradientColors);
}

class FeatureItem {
  final IconData icon;
  final String label;
  final Color color;

  const FeatureItem(this.icon, this.label, this.color);
}

class AlertItem {
  final String title;
  final String subtitle;
  final bool isUrgent;
  final String time;

  const AlertItem(this.title, this.subtitle, this.isUrgent, this.time);
}
