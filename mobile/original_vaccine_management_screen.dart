// lib/modules/vaccine_management/vaccine_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_management/vaccine_management_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Stats data class
class VaccineStats {
  final DateTime? nextAppointment;
  final int daysUntilNext;
  final int thisWeekCount;
  final int thisMonthCount;
  final int overdueCount;
  final int totalCompletedDoses;
  final int totalDoses;

  VaccineStats({
    this.nextAppointment,
    this.daysUntilNext = 0,
    this.thisWeekCount = 0,
    this.thisMonthCount = 0,
    this.overdueCount = 0,
    this.totalCompletedDoses = 0,
    this.totalDoses = 0,
  });
}

class VaccineManagementScreen extends GetView<VaccineManagementController> {
  const VaccineManagementScreen({super.key});

  static int _calculateDaysLeft(DateTime doseDateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final doseDay =
        DateTime(doseDateTime.year, doseDateTime.month, doseDateTime.day);
    return doseDay.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Container(
              color: ColorConstants.primaryGreen,
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: 'Tiến độ'),
                  Tab(text: 'Lịch sử tiêm chủng'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ProgressTab(), // Empty tab
                  _AppointmentsTab(), // Current management content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: ColorConstants.primaryGreen,
      toolbarHeight: 48,
      title: const Text(
        'Quản lý lịch tiêm chủng',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProgressTab extends StatefulWidget {
  const _ProgressTab();

  @override
  State<_ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<_ProgressTab> {
  final controller = Get.find<VaccineManagementController>();

  @override
  void initState() {
    super.initState();
    controller.fetchProgressData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final progressItems = controller.progressItems;

      if (progressItems.isEmpty) {
        return const Center(
          child: Text('Chưa có thông tin tiến độ'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: progressItems.length,
        itemBuilder: (context, index) {
          final item = progressItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: VaccineCard(item: item),
          );
        },
      );
    });
  }
}

class VaccineCard extends StatelessWidget {
  final VaccineProgressItem item;

  const VaccineCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.vaccineName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A4DFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Người tiêm: ${item.personName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF1A4DFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Đã lên lịch',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A4DFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Doses row
          Row(
            children: item.doses
                .map((dose) => Expanded(
                      child: _buildDoseColumn(dose),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseColumn(DoseProgress dose) {
    return Column(
      children: [
        Icon(
          dose.isScheduled ? Icons.access_time : Icons.calendar_today,
          size: 24,
          color: dose.isScheduled
              ? const Color(0xFF1A4DFF)
              : const Color(0xFF9CA3AF),
        ),
        const SizedBox(height: 8),
        Text(
          'Mũi ${dose.doseNumber}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dose.isScheduled ? 'Đã lên lịch' : 'Chưa lên lịch',
          style: TextStyle(
            fontSize: 12,
            color: dose.isScheduled
                ? const Color(0xFF1A4DFF)
                : const Color(0xFF9CA3AF),
          ),
        ),
        if (dose.isScheduled && dose.scheduledDate != null) ...[
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yyyy').format(dose.scheduledDate!),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ],
    );
  }
}

class _AppointmentsTab extends StatelessWidget {
  const _AppointmentsTab();

  void _navigateToAppointmentDetail(VaccineBooking booking) {
    // Navigate to appointment detail screen with booking data
    Get.toNamed(Routes.vaccineManagementAppointmentDetail, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VaccineManagementController>();

    return Obx(() {
      final upcomingBookings = controller.upcomingBookings;

      return Stack(
        children: [
          // Main scrollable content
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount:
                upcomingBookings.isNotEmpty ? upcomingBookings.length + 1 : 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header section
                return _buildManagementHeader(upcomingBookings);
              } else if (upcomingBookings.isEmpty && index == 1) {
                // Empty state
                return const _EmptyState(
                  icon: Icons.calendar_today,
                  title: 'Chưa có lịch hẹn nào',
                  subtitle: 'Hãy đặt lịch tiêm chủng mới',
                );
              } else {
                // Booking cards
                final bookingIndex = upcomingBookings.isEmpty ? 0 : index - 1;
                final booking = upcomingBookings[bookingIndex];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: VaccineBookingCard(
                    booking: booking,
                    onNavigateToDetail: _navigateToAppointmentDetail,
                    onRescheduleDose: (doseNumber) =>
                        _showRescheduleDialog(booking, doseNumber, context),
                    onCancelDose: (doseNumber) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header with icon
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Hủy lịch tiêm",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Mũi tiêm $doseNumber",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 20),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Warning message
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.orange.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "Bạn có chắc chắn muốn hủy mũi tiêm $doseNumber không? Hành động này không thể hoàn tác.",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF1E293B),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.grey[700],
                                            side: BorderSide(
                                                color: Colors.grey[400]!),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Giữ lịch tiêm",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Close the confirmation dialog first
                                            Navigator.of(dialogContext).pop();
                                            // Show success message
                                            Get.snackbar(
                                              "Đã hủy lịch tiêm",
                                              "Mũi tiêm $doseNumber đã được hủy thành công",
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Xác nhận hủy",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    onCancel: () => controller.cancelBooking(booking),
                    onBookingTap: _navigateToAppointmentDetail,
                  ),
                );
              }
            },
          ),
        ],
      );
    });
  }

  Widget _buildManagementHeader(List<VaccineBooking> upcomingBookings) {
    final controller = Get.find<VaccineManagementController>();

    // Count actual upcoming doses
    int upcomingDosesCount = _countUpcomingDoses(upcomingBookings);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFB3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Color(0xFF1976D2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quản lý lịch tiêm chủng',
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Theo dõi và quản lý tất cả lịch hẹn tiêm chủng của bạn một cách dễ dàng',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Quick stats row
            Row(
              children: [
                _buildQuickStat(
                  Icons.event_note,
                  upcomingBookings.length.toString(),
                  'Lịch hẹn',
                  const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 16),
                _buildQuickStat(
                  Icons.schedule,
                  upcomingDosesCount.toString(),
                  'Sắp tới',
                  const Color(0xFFFFC107),
                ),
                const SizedBox(width: 16),
                _buildQuickStat(
                  Icons.check_circle,
                  controller.completedBookings.length.toString(),
                  'Hoàn thành',
                  const Color(0xFF2196F3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  VaccineStats _calculateComprehensiveStats(
      List<VaccineBooking> upcomingBookings,
      List<VaccineBooking> completedBookings) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek
        .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    DateTime? nextAppointment;
    int daysUntilNext = 0;
    int thisWeekCount = 0;
    int thisMonthCount = 0;
    int overdueCount = 0;
    int totalCompletedDoses = 0;
    int totalDoses = 0;

    // Process upcoming bookings
    for (final booking in upcomingBookings) {
      for (final dose in booking.doseBookings.values) {
        totalDoses++;
        if (!dose.isCompleted) {
          final doseDate = dose.dateTime;
          final today = DateTime(now.year, now.month, now.day);
          final doseDay = DateTime(doseDate.year, doseDate.month, doseDate.day);
          final daysLeft = doseDay.difference(today).inDays;

          // Find next appointment
          if (nextAppointment == null || doseDate.isBefore(nextAppointment!)) {
            nextAppointment = doseDate;
            daysUntilNext = daysLeft > 0 ? daysLeft : 0;
          }

          // Count this week/month
          if (doseDate.isAfter(startOfWeek) && doseDate.isBefore(endOfWeek)) {
            thisWeekCount++;
          }
          if (doseDate.isAfter(startOfMonth) && doseDate.isBefore(endOfMonth)) {
            thisMonthCount++;
          }

          // Count overdue
          if (daysLeft < 0 || (daysLeft == 0 && doseDate.isBefore(now))) {
            overdueCount++;
          }
        }
      }
    }

    // Count completed doses from both upcoming and completed bookings
    for (final booking in [...upcomingBookings, ...completedBookings]) {
      for (final dose in booking.doseBookings.values) {
        if (dose.isCompleted) {
          totalCompletedDoses++;
        }
      }
    }

    return VaccineStats(
      nextAppointment: nextAppointment,
      daysUntilNext: daysUntilNext,
      thisWeekCount: thisWeekCount,
      thisMonthCount: thisMonthCount,
      overdueCount: overdueCount,
      totalCompletedDoses: totalCompletedDoses,
      totalDoses: totalDoses,
    );
  }

  int _calculateOverdueCount(List<VaccineBooking> bookings) {
    int overdueCount = 0;
    final now = DateTime.now();
    for (final booking in bookings) {
      for (final dose in booking.doseBookings.values) {
        if (!dose.isCompleted) {
          final today = DateTime(now.year, now.month, now.day);
          final doseDay = DateTime(
              dose.dateTime.year, dose.dateTime.month, dose.dateTime.day);
          final daysLeft = doseDay.difference(today).inDays;
          if (daysLeft < 0 || (daysLeft == 0 && dose.dateTime.isBefore(now))) {
            overdueCount++;
          }
        }
      }
    }
    return overdueCount;
  }

  int _countUpcomingDoses(List<VaccineBooking> bookings) {
    int count = 0;
    final now = DateTime.now();

    for (final booking in bookings) {
      for (final dose in booking.doseBookings.values) {
        if (!dose.isCompleted && dose.dateTime.isAfter(now)) {
          count++;
        }
      }
    }

    return count;
  }

  Widget _buildQuickStat(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(IconData mainIcon, String value, String label,
      Color color, IconData bgIcon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Background icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(bgIcon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          // Value
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VaccinationRecordsTab extends StatelessWidget {
  const _VaccinationRecordsTab();

  void _navigateToAppointmentDetail(VaccineBooking booking) {
    // Navigate to appointment detail screen with booking data
    Get.toNamed(Routes.vaccineManagementAppointmentDetail, arguments: booking);
  }

  void _navigateToVaccinationCertificate(VaccineBooking booking) {
    // Navigate to vaccination certificate screen with booking data
    Get.toNamed(Routes.vaccinationCertificate, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VaccineManagementController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final completedBookings = controller.completedBookings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RecordsHeader(onExport: controller.exportToPDF),
            const SizedBox(height: 16),
            if (completedBookings.isEmpty)
              const _EmptyState(
                icon: Icons.medical_services,
                title: 'Chưa có lịch sử tiêm chủng',
                subtitle: 'Các mũi tiêm đã hoàn thành sẽ hiển thị tại đây',
              )
            else
              ...completedBookings.map((booking) => VaccinationHistoryCard(
                    booking: booking,
                    onDownload: () => controller.downloadCertificate(booking),
                    onBookingTap: _navigateToVaccinationCertificate,
                  )),
          ],
        );
      }),
    );
  }
}

class _RecordsHeader extends StatelessWidget {
  final VoidCallback onExport;

  const _RecordsHeader({required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionTitle('Hồ sơ tiêm chủng'),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf,
                  color: ColorConstants.primaryGreen, size: 28),
              onPressed: onExport,
              tooltip: 'Xuất PDF toàn bộ hồ sơ',
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Lịch sử các mũi tiêm',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ColorConstants.primaryGreen,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(Routes.vaccineList);
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Đặt lịch tiêm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VaccineBookingCard extends StatelessWidget {
  final VaccineBooking booking;
  final Function(VaccineBooking) onNavigateToDetail;
  final Function(int) onRescheduleDose;
  final Function(int) onCancelDose;
  final VoidCallback onCancel;
  final Function(VaccineBooking)? onBookingTap;

  const VaccineBookingCard({
    super.key,
    required this.booking,
    required this.onNavigateToDetail,
    required this.onRescheduleDose,
    required this.onCancelDose,
    required this.onCancel,
    this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    final sortedDoses = _getSortedDoses(booking);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onBookingTap != null ? () => onBookingTap!(booking) : null,
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorConstants.primaryGreen.withOpacity(0.05),
        highlightColor: ColorConstants.primaryGreen.withOpacity(0.02),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookingHeader(booking: booking, onBookingTap: onBookingTap),
              const SizedBox(height: 16),
              ...sortedDoses.map((dose) => _DoseSection(
                    dose: dose,
                    booking: booking,
                    onNavigateToDetail: onNavigateToDetail,
                    onRescheduleDose: onRescheduleDose,
                    onCancelDose: onCancelDose,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<DoseBooking> _getSortedDoses(VaccineBooking booking) {
    return booking.doseBookings.values.toList()
      ..sort((a, b) => a.vaccineDoseNumber.compareTo(b.vaccineDoseNumber));
  }
}

class _BookingHeader extends StatelessWidget {
  final VaccineBooking booking;
  final Function(VaccineBooking)? onBookingTap;

  const _BookingHeader({required this.booking, this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBookingTap != null ? () => onBookingTap!(booking) : null,
      child: Row(
        children: [
          const Icon(
            Icons.vaccines,
            color: ColorConstants.secondaryGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking.vaccines.map((v) => v.name).join(', '),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: onBookingTap != null
                                ? ColorConstants.primaryGreen
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (booking.vaccines.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      booking.vaccines.first.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (booking.confirmationCode != null &&
                    booking.confirmationCode!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Mã đặt lịch: ${booking.confirmationCode}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _StatusBadge(status: booking.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, text) = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  (Color, String) _getStatusInfo(String status) {
    return switch (status) {
      'completed' => (Colors.green, 'Đã tiêm'),
      'partially_completed' => (Colors.green, 'Đã tiêm một phần'),
      'cancelled' => (Colors.red, 'Đã hủy'),
      'in_progress' => (ColorConstants.secondaryGreen, 'Đang tiến hành'),
      _ => (ColorConstants.secondaryGreen, 'Sắp tới'),
    };
  }
}

class _DoseSection extends StatelessWidget {
  final DoseBooking dose;
  final VaccineBooking booking;
  final Function(VaccineBooking) onNavigateToDetail;
  final Function(int) onRescheduleDose;
  final Function(int) onCancelDose;

  const _DoseSection({
    required this.dose,
    required this.booking,
    required this.onNavigateToDetail,
    required this.onRescheduleDose,
    required this.onCancelDose,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VaccineManagementController>();
    final daysLeft = !dose.isCompleted
        ? (() {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final doseDay = DateTime(
                dose.dateTime.year, dose.dateTime.month, dose.dateTime.day);
            return doseDay.difference(today).inDays;
          })()
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dose.isCompleted
              ? [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1)]
              : [const Color(0xFFF8FAFC), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dose.isCompleted
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onNavigateToDetail(booking),
        borderRadius: BorderRadius.circular(12),
        splashColor: ColorConstants.primaryGreen.withOpacity(0.1),
        highlightColor: ColorConstants.primaryGreen.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: dose.isCompleted
                            ? [Colors.green, const Color(0xFF059669)]
                            : [
                                ColorConstants.primaryGreen,
                                ColorConstants.secondaryGreen
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mũi ${dose.vaccineDoseNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Builder(
                    builder: (context) {
                      if (dose.isCompleted) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Đã hoàn thành',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else if (daysLeft < 0 ||
                          (daysLeft == 0 &&
                              dose.dateTime.isBefore(DateTime.now()))) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Đã quá hạn',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      } else if (daysLeft == 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  ColorConstants.primaryGreen.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Hôm nay',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.primaryGreen,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  ColorConstants.primaryGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Còn $daysLeft ngày',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.primaryGreen,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDoseDetailItem(
                      icon: Icons.calendar_today,
                      title: 'Ngày tiêm',
                      value: DateFormat('dd/MM/yyyy').format(dose.dateTime),
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDoseDetailItem(
                      icon: Icons.access_time,
                      title: 'Giờ tiêm',
                      value: DateFormat('HH:mm').format(dose.dateTime),
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDoseDetailItem(
                icon: Icons.location_on,
                title: 'Địa điểm',
                value: dose.facility.name,
                color: const Color(0xFF10B981),
              ),
              if (!dose.isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _DoseActions(
                      dose: dose,
                      onRescheduleDose: onRescheduleDose,
                      onCancelDose: onCancelDose),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoseDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DoseHeader extends StatelessWidget {
  final DoseBooking dose;
  final int daysLeft;

  const _DoseHeader({required this.dose, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Mũi ${dose.vaccineDoseNumber}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color:
                dose.isCompleted ? Colors.green : ColorConstants.secondaryGreen,
          ),
        ),
        const Spacer(),
        if (!dose.isCompleted && daysLeft > 0)
          Text(
            'Còn $daysLeft ngày',
            style: TextStyle(
              fontSize: 12,
              color: daysLeft <= 3 ? Colors.orange : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (!dose.isCompleted && daysLeft <= 0)
          const Text(
            'Đã quá hạn',
            style: TextStyle(
              fontSize: 12,
              color: Colors.yellow,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (dose.isCompleted)
          const Text(
            'Đã hoàn thành',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

class _DoseDetails extends StatelessWidget {
  final DoseBooking dose;

  const _DoseDetails({required this.dose});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailRow(
          icon: Icons.calendar_today,
          text: DateFormat('dd/MM/yyyy').format(dose.dateTime),
        ),
        const SizedBox(height: 4),
        DetailRow(
          icon: Icons.access_time,
          text: DateFormat('HH:mm').format(dose.dateTime),
        ),
        const SizedBox(height: 4),
        DetailRow(
          icon: Icons.location_on,
          text: dose.facility.name,
        ),
      ],
    );
  }
}

class _DoseActions extends StatelessWidget {
  final DoseBooking dose;
  final Function(int) onRescheduleDose;
  final Function(int) onCancelDose;

  const _DoseActions({
    required this.dose,
    required this.onRescheduleDose,
    required this.onCancelDose,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = !dose.isCompleted
        ? (() {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final doseDay = DateTime(
                dose.dateTime.year, dose.dateTime.month, dose.dateTime.day);
            return doseDay.difference(today).inDays;
          })()
        : 0;
    final isOverdue = (daysLeft < 0 ||
            (daysLeft == 0 && dose.dateTime.isBefore(DateTime.now()))) &&
        !dose.isCompleted;

    // For overdue/missed doses, only show reschedule button
    if (isOverdue) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => onRescheduleDose(dose.vaccineDoseNumber),
              icon: const Icon(Icons.edit_calendar, size: 16),
              label: const Text('Đổi lịch'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorConstants.primaryGreen,
                side: BorderSide(
                    color: ColorConstants.primaryGreen.withOpacity(0.5)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // For upcoming doses, show both buttons
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onRescheduleDose(dose.vaccineDoseNumber),
            icon: const Icon(Icons.edit_calendar, size: 16),
            label: const Text('Đổi lịch'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorConstants.primaryGreen,
              side: BorderSide(
                  color: ColorConstants.primaryGreen.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onCancelDose(dose.vaccineDoseNumber),
            icon: const Icon(Icons.cancel, size: 16),
            label: const Text('Hủy lịch'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VaccinationHistoryCard extends StatelessWidget {
  final VaccineBooking booking;
  final VoidCallback onDownload;
  final Function(VaccineBooking)? onBookingTap;

  const VaccinationHistoryCard({
    super.key,
    required this.booking,
    required this.onDownload,
    this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedDoses = _getCompletedDoses(booking);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onBookingTap != null ? () => onBookingTap!(booking) : null,
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorConstants.primaryGreen.withOpacity(0.05),
        highlightColor: ColorConstants.primaryGreen.withOpacity(0.02),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistoryHeader(
                booking: booking,
                onDownload: onDownload,
                onBookingTap: onBookingTap,
              ),
              const SizedBox(height: 12),
              ...completedDoses.map((dose) => _CompletedDose(dose: dose)),
            ],
          ),
        ),
      ),
    );
  }

  List<DoseBooking> _getCompletedDoses(VaccineBooking booking) {
    return booking.doseBookings.values
        .where((dose) => dose.isCompleted)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
}

class _HistoryHeader extends StatelessWidget {
  final VaccineBooking booking;
  final VoidCallback onDownload;
  final Function(VaccineBooking)? onBookingTap;

  const _HistoryHeader({
    required this.booking,
    required this.onDownload,
    this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.vaccines, color: ColorConstants.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.vaccines.map((v) => v.name).join(', '),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: onBookingTap != null
                              ? ColorConstants.primaryGreen
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (booking.vaccines.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    booking.vaccines.first.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.download, color: ColorConstants.primaryGreen),
          onPressed: onDownload,
          tooltip: 'Tải chứng nhận',
        ),
      ],
    );
  }
}

class _CompletedDose extends StatelessWidget {
  final DoseBooking dose;

  const _CompletedDose({required this.dose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mũi ${dose.vaccineDoseNumber}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        DetailRow(
          icon: Icons.calendar_today,
          text: DateFormat('dd/MM/yyyy').format(dose.dateTime),
        ),
        const SizedBox(height: 4),
        DetailRow(
          icon: Icons.location_on,
          text: dose.facility.name,
        ),
        const SizedBox(height: 4),
        const DetailRow(
          icon: Icons.verified,
          text: 'Đã hoàn thành',
          textColor: Colors.green,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;

  const DetailRow({
    super.key,
    required this.icon,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? const Color(0xFF475569),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

void _showRescheduleDialog(
    VaccineBooking booking, int doseNumber, BuildContext context) {
  final controller = Get.find<VaccineManagementController>();
  final doseBooking = booking.doseBookings.values
      .firstWhere((dose) => dose.vaccineDoseNumber == doseNumber);

  final (minDate, validationMessage, doseSpacingInfo) =
      controller.calculateDoseConstraints(booking, doseNumber, doseBooking);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final effectiveMinDate =
      (minDate != null && minDate.isBefore(today)) ? today : minDate ?? today;

  final initialDate = doseBooking.dateTime;
  final initialTime = TimeOfDay.fromDateTime(doseBooking.dateTime);
  final availableTimeSlots = controller.generateHourlyTimeSlots(8, 17);

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RescheduleDialogContent(
        booking: booking,
        doseNumber: doseNumber,
        doseBooking: doseBooking,
        initialDate: initialDate,
        initialTime: initialTime,
        effectiveMinDate: effectiveMinDate,
        availableTimeSlots: availableTimeSlots,
        validationMessage: validationMessage,
        doseSpacingInfo: doseSpacingInfo,
        minDate: minDate,
      ),
    ),
    barrierDismissible: true, // Allow closing by tapping outside
  );
}

// RescheduleDialogContent class for handling reschedule dialog

// Stateful widget for the dialog content
class RescheduleDialogContent extends StatefulWidget {
  final VaccineBooking booking;
  final int doseNumber;
  final DoseBooking doseBooking;
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final DateTime effectiveMinDate;
  final List<TimeOfDay> availableTimeSlots;
  final String? validationMessage;
  final String? doseSpacingInfo;
  final DateTime? minDate;

  const RescheduleDialogContent({
    super.key,
    required this.booking,
    required this.doseNumber,
    required this.doseBooking,
    required this.initialDate,
    required this.initialTime,
    required this.effectiveMinDate,
    required this.availableTimeSlots,
    this.validationMessage,
    this.doseSpacingInfo,
    this.minDate,
  });

  @override
  State<RescheduleDialogContent> createState() =>
      _RescheduleDialogContentState();
}

class _RescheduleDialogContentState extends State<RescheduleDialogContent> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late TextEditingController reasonController;
  bool _isProcessingReschedule = false;
  bool _isDatePickerOpen = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: ColorConstants.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Đổi lịch mũi tiêm ${widget.doseNumber}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Vaccine info
            Text(
              "Vaccine: ${widget.booking.vaccines.map((v) => v.name).join(', ')}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 12),

            // Dose spacing information
            if (widget.doseSpacingInfo != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doseSpacingInfo!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

            // Date selection
            const Text(
              "Ngày tiêm mới:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, size: 20),
                title: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  // Prevent multiple date pickers and reschedule processing
                  if (_isDatePickerOpen || _isProcessingReschedule || !mounted)
                    return;

                  // Set flag to prevent multiple openings
                  setState(() {
                    _isDatePickerOpen = true;
                  });

                  try {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: widget.effectiveMinDate,
                      lastDate: widget.effectiveMinDate
                          .add(const Duration(days: 365)),
                      selectableDayPredicate: (DateTime day) {
                        // Prevent selecting past dates and Sundays
                        return day.isAfter(widget.effectiveMinDate
                                .subtract(const Duration(days: 1))) &&
                            day.weekday != DateTime.sunday;
                      },
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: ColorConstants.primaryGreen,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogTheme:
                                DialogThemeData(backgroundColor: Colors.white),
                          ),
                          child: child!,
                        );
                      },
                    );

                    // Only update if we got a valid date and component is still mounted
                    if (pickedDate != null &&
                        pickedDate != selectedDate &&
                        mounted &&
                        !_isProcessingReschedule) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  } finally {
                    // Always reset the flag
                    if (mounted) {
                      setState(() {
                        _isDatePickerOpen = false;
                      });
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            // Time selection with grid of available time slots
            const Text(
              "Giờ tiêm mới:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            Text(
              "Chọn khung giờ trống:",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),

            // Grid of time slots
            SizedBox(
              height: 120,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.2,
                ),
                itemCount: widget.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = widget.availableTimeSlots[index];
                  final isSelected = selectedTime.hour == timeSlot.hour &&
                      selectedTime.minute == timeSlot.minute;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = timeSlot;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorConstants.primaryGreen
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? ColorConstants.primaryGreen
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          formatTime(timeSlot),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Reason input
            const Text(
              "Lý do đổi lịch:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: reasonController,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Ví dụ: Bận việc đột xuất, thay đổi địa điểm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: ColorConstants.primaryGreen),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            // Validation message
            if (widget.validationMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.validationMessage!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Hủy"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Validate date constraints
                      if (widget.minDate != null &&
                          newDateTime.isBefore(widget.minDate!)) {
                        Get.snackbar(
                          "Lỗi",
                          widget.validationMessage!,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Validate not in past
                      if (newDateTime.isBefore(DateTime.now())) {
                        Get.snackbar(
                          "Lỗi",
                          "Không thể chọn ngày giờ trong quá khứ",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Validate reason is not empty
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        Get.snackbar(
                          "Lỗi",
                          "Vui lòng nhập lý do đổi lịch",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Set flags to prevent any further interactions
                      setState(() {
                        _isProcessingReschedule = true;
                        _isDatePickerOpen =
                            false; // Ensure date picker is closed
                      });

                      // Store the operations to perform after dialog closes
                      operations() async {
                        try {
                          final controller =
                              Get.find<VaccineManagementController>();

                          // Reschedule the dose with the new date/time and reason
                          await controller.rescheduleDose(
                              widget.booking,
                              widget.doseNumber,
                              newDateTime,
                              reasonController.text.trim());

                          // Show success message
                          Get.snackbar(
                            "Thành công",
                            "Đã yêu cầu đổi lịch mũi tiêm ${widget.doseNumber}",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } catch (e) {
                          Get.snackbar(
                            "Lỗi",
                            "Có lỗi xảy ra khi đổi lịch: ${e.toString()}",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }

                      // Close the reschedule dialog specifically
                      if (mounted) {
                        Navigator.of(context).pop();
                        // Execute operations immediately after dialog is closed
                        operations();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Xác nhận đổi lịch"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }
}
