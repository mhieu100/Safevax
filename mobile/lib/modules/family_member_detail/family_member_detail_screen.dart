// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/modules/family_member_detail/family_member_detail_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FamilyMemberDetailScreen extends GetView<FamilyMemberDetailController> {
  const FamilyMemberDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'Thông tin người thân',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorConstants.primaryGreen,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Tiến độ'),
              Tab(text: 'Lịch sử tiêm chủng'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF2563EB)),
              ),
            );
          }

          return TabBarView(
            children: [
              _OverviewTab(),
              _ProgressTab(),
              _VaccinationHistoryTab(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
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
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF1976D2),
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.memberDetail['fullName'] ??
                            controller.member?.name ??
                            'Thành viên',
                        style: TextStyle(
                          color: const Color(0xFF0D47A1),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Lịch tiêm chủng của ${controller.memberDetail['fullName'] ?? controller.member?.name ?? 'thành viên'}',
                        style: TextStyle(
                          color: const Color(0xFF1565C0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      if (controller.memberDetail.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _buildDetailChip(
                              'Tuổi: ${_calculateAge(controller.memberDetail['dateOfBirth'])}',
                              Icons.cake,
                              const Color(0xFFE3F2FD),
                              const Color(0xFF1976D2),
                            ),
                            SizedBox(width: 8.w),
                            _buildDetailChip(
                              'Giới tính: ${controller.memberDetail['gender'] == 'MALE' ? 'Nam' : 'Nữ'}',
                              Icons.person,
                              const Color(0xFFFCE4EC),
                              const Color(0xFFC2185B),
                            ),
                          ],
                        ),
                        if (controller.memberDetail['phone'] != null &&
                            controller.memberDetail['phone']
                                .toString()
                                .isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          _buildDetailChip(
                            'Số điện thoại: ${controller.memberDetail['phone']}',
                            Icons.phone,
                            const Color(0xFFE8F5E8),
                            const Color(0xFF2E7D32),
                          ),
                        ],
                        if (controller.memberDetail['heightCm'] != null ||
                            controller.memberDetail['weightKg'] != null) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              if (controller.memberDetail['heightCm'] != null)
                                _buildDetailChip(
                                  'Cao: ${controller.memberDetail['heightCm']}cm',
                                  Icons.height,
                                  const Color(0xFFE8F5E8),
                                  const Color(0xFF2E7D32),
                                ),
                              if (controller.memberDetail['heightCm'] != null &&
                                  controller.memberDetail['weightKg'] != null)
                                SizedBox(width: 8.w),
                              if (controller.memberDetail['weightKg'] != null)
                                _buildDetailChip(
                                  'Nặng: ${controller.memberDetail['weightKg']}kg',
                                  Icons.monitor_weight,
                                  const Color(0xFFFFF3E0),
                                  const Color(0xFFEF6C00),
                                ),
                            ],
                          ),
                        ],
                        SizedBox(height: 8.h),
                        _buildVaccinationStatus(
                            controller.memberDetail['vaccinationStatus']),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Quick stats row - now clickable
            Row(
              children: [
                _buildClickableQuickStat(
                  Icons.event_note,
                  controller.appointments.length.toString(),
                  'Lịch hẹn',
                  const Color(0xFF4CAF50),
                  'all',
                ),
                SizedBox(width: 16.w),
                _buildClickableQuickStat(
                  Icons.schedule,
                  controller.appointments
                      .where((a) => a.status == AppointmentStatus.upcoming)
                      .length
                      .toString(),
                  'Sắp tới',
                  const Color(0xFFFF9800),
                  'upcoming',
                ),
                SizedBox(width: 16.w),
                _buildClickableQuickStat(
                  Icons.check_circle,
                  controller.appointments
                      .where((a) => a.status == AppointmentStatus.completed)
                      .length
                      .toString(),
                  'Hoàn thành',
                  const Color(0xFF2196F3),
                  'completed',
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableQuickStat(IconData icon, String value, String label,
      Color color, String filterType) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == filterType;
        // Use white text for orange color, otherwise use the color
        final textColor = color;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.changeTab(filterType),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (color == const Color(0xFFFF9800)
                        ? color.withOpacity(0.02)
                        : color.withOpacity(0.1))
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
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
        onTap: () => _viewAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorConstants.primaryGreen.withOpacity(0.05),
        highlightColor: ColorConstants.primaryGreen.withOpacity(0.02),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppointmentHeader(appointment: appointment),
              const SizedBox(height: 16),
              _AppointmentDetails(appointment: appointment),
            ],
          ),
        ),
      ),
    );
  }

  void _viewAppointmentDetails(Appointment appointment) {
    if (appointment.bookingId != null) {
      // Find the corresponding VaccineBooking
      final booking = controller.bookings.firstWhereOrNull(
        (b) => b.id == appointment.bookingId,
      );
      if (booking != null) {
        Get.toNamed(Routes.vaccineManagementAppointmentDetail,
            arguments: booking);
      }
    }
  }

  Widget _buildDetailChip(
      String text, IconData icon, Color backgroundColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationStatus(String? status) {
    if (status == null) return const SizedBox.shrink();

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'NOT_STARTED':
        statusColor = Colors.grey;
        statusText = 'Chưa bắt đầu tiêm chủng';
        statusIcon = Icons.schedule;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange;
        statusText = 'Đang trong quá trình tiêm chủng';
        statusIcon = Icons.play_arrow;
        break;
      case 'COMPLETED':
        statusColor = Colors.green;
        statusText = 'Đã hoàn thành tiêm chủng';
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Trạng thái không xác định';
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 6.w),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.sp,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'Không rõ';

    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age tuổi';
    } catch (e) {
      return 'Không rõ';
    }
  }
}

class _AppointmentHeader extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentHeader({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.vaccines,
              color: ColorConstants.secondaryGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      appointment.vaccineName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusBadge(status: appointment.status),
                ],
              ),
            ),
          ],
        ),
        if (appointment.statusText != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Colors.orange[700],
                ),
                const SizedBox(width: 6),
                Text(
                  appointment.statusText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

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

  (Color, String) _getStatusInfo(AppointmentStatus status) {
    return switch (status) {
      AppointmentStatus.completed => (Colors.green, 'Đã hoàn thành'),
      AppointmentStatus.missed => (Colors.red, 'Đã bỏ lỡ'),
      AppointmentStatus.upcoming => (ColorConstants.secondaryGreen, 'Sắp tới'),
    };
  }
}

class _AppointmentDetails extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentDetails({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: appointment.status == AppointmentStatus.completed
              ? [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1)]
              : [const Color(0xFFF8FAFC), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appointment.status == AppointmentStatus.completed
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildAppointmentDetailItem(
                    icon: Icons.calendar_today,
                    title: 'Ngày tiêm',
                    value: DateFormat('dd/MM/yyyy', 'vi_VN')
                        .format(appointment.date),
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAppointmentDetailItem(
                    icon: Icons.access_time,
                    title: 'Giờ tiêm',
                    value: appointment.timeSlot != null
                        ? Get.find<FamilyMemberDetailController>()
                            .getDisplayTimeRange(appointment.timeSlot!)
                        : DateFormat('HH:mm').format(appointment.date),
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAppointmentDetailItem(
              icon: Icons.location_on,
              title: 'Địa điểm',
              value: appointment.clinic,
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailItem({
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FamilyMemberDetailController>();
    return Stack(
      children: [
        // Single scrollable list containing header and appointment cards
        Obx(() {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount:
                controller.filteredAppointments.length + 1, // +1 for header
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header item
                return _buildOverviewHeaderCard(controller);
              } else {
                // Appointment card item
                final appointmentIndex = index - 1;
                final appointment =
                    controller.filteredAppointments[appointmentIndex];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: _buildOverviewAppointmentCard(appointment),
                );
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildOverviewHeaderCard(FamilyMemberDetailController controller) {
    return Container(
      margin: EdgeInsets.all(16.w),
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
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF1976D2),
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.memberDetail['fullName'] ??
                            controller.member?.name ??
                            'Thành viên',
                        style: TextStyle(
                          color: const Color(0xFF0D47A1),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Lịch tiêm chủng của ${controller.memberDetail['fullName'] ?? controller.member?.name ?? 'thành viên'}',
                        style: TextStyle(
                          color: const Color(0xFF1565C0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      if (controller.memberDetail.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _buildDetailChip(
                              'Tuổi: ${_calculateAge(controller.memberDetail['dateOfBirth'])}',
                              Icons.cake,
                              const Color(0xFFE3F2FD),
                              const Color(0xFF1976D2),
                            ),
                            SizedBox(width: 8.w),
                            _buildDetailChip(
                              'Giới tính: ${controller.memberDetail['gender'] == 'MALE' ? 'Nam' : 'Nữ'}',
                              Icons.person,
                              const Color(0xFFFCE4EC),
                              const Color(0xFFC2185B),
                            ),
                          ],
                        ),
                        if (controller.memberDetail['phone'] != null &&
                            controller.memberDetail['phone']
                                .toString()
                                .isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          _buildDetailChip(
                            'Số điện thoại: ${controller.memberDetail['phone']}',
                            Icons.phone,
                            const Color(0xFFE8F5E8),
                            const Color(0xFF2E7D32),
                          ),
                        ],
                        if (controller.memberDetail['heightCm'] != null ||
                            controller.memberDetail['weightKg'] != null) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              if (controller.memberDetail['heightCm'] != null)
                                _buildDetailChip(
                                  'Cao: ${controller.memberDetail['heightCm']}cm',
                                  Icons.height,
                                  const Color(0xFFE8F5E8),
                                  const Color(0xFF2E7D32),
                                ),
                              if (controller.memberDetail['heightCm'] != null &&
                                  controller.memberDetail['weightKg'] != null)
                                SizedBox(width: 8.w),
                              if (controller.memberDetail['weightKg'] != null)
                                _buildDetailChip(
                                  'Nặng: ${controller.memberDetail['weightKg']}kg',
                                  Icons.monitor_weight,
                                  const Color(0xFFFFF3E0),
                                  const Color(0xFFEF6C00),
                                ),
                            ],
                          ),
                        ],
                        SizedBox(height: 8.h),
                        _buildVaccinationStatus(
                            controller.memberDetail['vaccinationStatus']),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Quick stats row - now clickable
            Row(
              children: [
                _buildClickableQuickStat(
                  Icons.event_note,
                  controller.appointments.length.toString(),
                  'Lịch hẹn',
                  const Color(0xFF4CAF50),
                  'all',
                ),
                SizedBox(width: 16.w),
                _buildClickableQuickStat(
                  Icons.schedule,
                  controller.appointments
                      .where((a) => a.status == AppointmentStatus.upcoming)
                      .length
                      .toString(),
                  'Sắp tới',
                  const Color(0xFFFF9800),
                  'upcoming',
                ),
                SizedBox(width: 16.w),
                _buildClickableQuickStat(
                  Icons.check_circle,
                  controller.appointments
                      .where((a) => a.status == AppointmentStatus.completed)
                      .length
                      .toString(),
                  'Hoàn thành',
                  const Color(0xFF2196F3),
                  'completed',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewAppointmentCard(Appointment appointment) {
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
        onTap: () => _viewAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(16),
        splashColor: ColorConstants.primaryGreen.withOpacity(0.05),
        highlightColor: ColorConstants.primaryGreen.withOpacity(0.02),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppointmentHeader(appointment: appointment),
              const SizedBox(height: 16),
              _AppointmentDetails(appointment: appointment),
            ],
          ),
        ),
      ),
    );
  }

  void _viewAppointmentDetails(Appointment appointment) {
    final controller = Get.find<FamilyMemberDetailController>();
    if (appointment.bookingId != null) {
      // Find the corresponding VaccineBooking
      final booking = controller.bookings.firstWhereOrNull(
        (b) => b.id == appointment.bookingId,
      );
      if (booking != null) {
        Get.toNamed(Routes.vaccineManagementAppointmentDetail,
            arguments: booking);
      }
    }
  }

  Widget _buildDetailChip(
      String text, IconData icon, Color backgroundColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationStatus(String? status) {
    if (status == null) return const SizedBox.shrink();

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'NOT_STARTED':
        statusColor = Colors.grey;
        statusText = 'Chưa bắt đầu tiêm chủng';
        statusIcon = Icons.schedule;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange;
        statusText = 'Đang trong quá trình tiêm chủng';
        statusIcon = Icons.play_arrow;
        break;
      case 'COMPLETED':
        statusColor = Colors.green;
        statusText = 'Đã hoàn thành tiêm chủng';
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Trạng thái không xác định';
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 6.w),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.sp,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'Không rõ';

    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age tuổi';
    } catch (e) {
      return 'Không rõ';
    }
  }

  Widget _buildClickableQuickStat(IconData icon, String value, String label,
      Color color, String filterType) {
    final controller = Get.find<FamilyMemberDetailController>();
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == filterType;
        // Use white text for orange color, otherwise use the color
        final textColor = color;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.changeTab(filterType),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (color == const Color(0xFFFF9800)
                        ? color.withOpacity(0.02)
                        : color.withOpacity(0.1))
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ProgressTab extends StatefulWidget {
  const _ProgressTab();

  @override
  State<_ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<_ProgressTab> {
  final controller = Get.find<FamilyMemberDetailController>();

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

class _VaccinationHistoryTab extends StatelessWidget {
  const _VaccinationHistoryTab();

  void _navigateToVaccinationCertificate(GroupedBookingData booking) {
    // Navigate to vaccination certificate screen with booking data
    Get.toNamed(Routes.vaccinationCertificate, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FamilyMemberDetailController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final allBookings = controller.groupedBookings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RecordsHeader(),
            const SizedBox(height: 16),
            if (allBookings.isEmpty)
              const _EmptyState(
                icon: Icons.medical_services,
                title: 'Chưa có lịch sử tiêm chủng',
                subtitle: 'Các mũi tiêm đã hoàn thành sẽ hiển thị tại đây',
              )
            else
              ...allBookings.map((booking) => VaccinationHistoryCard(
                    booking: booking,
                    onBookingTap: _navigateToVaccinationCertificate,
                  )),
          ],
        );
      }),
    );
  }
}

class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Hồ sơ tiêm chủng'),
        const SizedBox(height: 8),
        const Text(
          'Lịch sử các mũi tiêm',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
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
    return Padding(
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
        ],
      ),
    );
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

class VaccinationHistoryCard extends StatelessWidget {
  final GroupedBookingData booking;
  final Function(GroupedBookingData)? onBookingTap;

  const VaccinationHistoryCard({
    super.key,
    required this.booking,
    this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onBookingTap != null ? () => onBookingTap!(booking) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistoryHeader(
                booking: booking,
                onBookingTap: onBookingTap,
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text(
                  'Chi tiết mũi tiêm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryGreen,
                  ),
                ),
                children: _buildAppointmentItems(),
                initiallyExpanded: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppointmentItems() {
    final sortedAppointments = booking.appointments
      ..sort((a, b) => a.doseNumber.compareTo(b.doseNumber));

    return sortedAppointments
        .map((appointment) => _AppointmentItem(appointment: appointment))
        .toList();
  }
}

class _HistoryHeader extends StatelessWidget {
  final GroupedBookingData booking;
  final Function(GroupedBookingData)? onBookingTap;

  const _HistoryHeader({
    required this.booking,
    this.onBookingTap,
  });

  Color _getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' => Colors.green,
      'ongoing' => Colors.teal,
      _ => Colors.orange,
    };
  }

  String _getStatusText(String status) {
    return switch (status.toLowerCase()) {
      'ongoing' => 'Đang tiến hành',
      'pending' => 'Đang chờ',
      'scheduled' => 'Đã xử lý',
      _ => StringExtension(status).capitalizeFirst(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final displayName = booking.patientName;
    final formattedAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(booking.totalAmount);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.parse(booking.createdAt));

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.vaccineName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.primaryGreen,
                ),
              ),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailRow(
                  icon: Icons.confirmation_number,
                  text: 'Mã đặt lịch: ${booking.routeId}',
                ),
              ),
              Expanded(
                child: DetailRow(
                  icon: Icons.attach_money,
                  text: 'Tổng tiền: $formattedAmount',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: DetailRow(
                  icon: Icons.vaccines,
                  text: 'Tổng mũi: ${booking.requiredDoses}',
                ),
              ),
              Expanded(
                child: DetailRow(
                  icon: Icons.schedule,
                  text: 'Ngày tạo: $formattedDate',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          DetailRow(
            icon: Icons.info,
            text: 'Trạng thái: ${_getStatusText(booking.status)}',
            textColor: _getStatusColor(booking.status),
          ),
        ],
      ),
    );
  }
}

class _AppointmentItem extends StatelessWidget {
  final GroupedAppointmentData appointment;

  const _AppointmentItem({required this.appointment});

  String _formatTimeSlot(String timeSlot) {
    // Parse SLOT_HH_MM to HH:MM - (HH+2):MM
    final parts = timeSlot.split('_');
    if (parts.length >= 3) {
      final hour = int.tryParse(parts[1]) ?? 0;
      final minute = int.tryParse(parts[2]) ?? 0;
      final startTime =
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      final endHour = hour + 2;
      final endTime =
          '${endHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      return '$startTime - $endTime';
    }
    return timeSlot; // Fallback
  }

  Color _getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' => Colors.green,
      'cancelled' => Colors.red,
      'initial' => Colors.blue,
      'in_progress' => ColorConstants.secondaryGreen,
      'ongoing' => Colors.teal,
      _ => Colors.orange,
    };
  }

  String _getStatusText(String status) {
    return switch (status.toLowerCase()) {
      'ongoing' => 'Đang tiến hành',
      _ => StringExtension(status).capitalizeFirst(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.appointmentStatus);
    final statusIcon =
        appointment.appointmentStatus.toLowerCase() == 'completed'
            ? Icons.check_circle
            : appointment.appointmentStatus.toLowerCase() == 'cancelled'
                ? Icons.cancel
                : Icons.schedule;

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mũi ${appointment.doseNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.primaryGreen,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.calendar_today,
                    label: 'Ngày tiêm',
                    value: DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(appointment.scheduledDate)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.access_time,
                    label: 'Giờ',
                    value: _formatTimeSlot(appointment.scheduledTimeSlot),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.location_on,
                    label: 'Địa điểm',
                    value: appointment.centerName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.person,
                    label: 'Bác sĩ',
                    value: appointment.doctorName ?? 'Chưa cập nhật',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.info,
                    label: 'Trạng thái',
                    value: _getStatusText(appointment.appointmentStatus),
                    valueColor: statusColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AppointmentDetail(
                    icon: Icons.person_outline,
                    label: 'Thu ngân',
                    value: 'Chưa cập nhật',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _AppointmentDetail({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? const Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
