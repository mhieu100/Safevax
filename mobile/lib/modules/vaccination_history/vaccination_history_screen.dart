import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/modules/vaccination_history/vaccination_history_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class VaccinationHistoryScreen extends GetView<VaccinationHistoryController> {
  const VaccinationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightBackGround,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ColorConstants.primaryGreen,
        toolbarHeight: 48,
        title: const Text(
          'Lịch sử tiêm chủng',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final bookingHistory = controller.bookingHistory;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _RecordsHeader(),
                  const SizedBox(height: 16),
                  if (bookingHistory.isEmpty)
                    const _EmptyState(
                      icon: Icons.medical_services,
                      title: 'Chưa có lịch sử tiêm chủng',
                      subtitle:
                          'Các mũi tiêm đã hoàn thành sẽ hiển thị tại đây',
                    )
                  else
                    const SizedBox.shrink(),
                ]),
              ),
            ),
            if (bookingHistory.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final booking = bookingHistory[index];
                      return VaccinationHistoryCard(
                        booking: booking,
                        onBookingTap: _navigateToVaccinationCertificate,
                      );
                    },
                    childCount: bookingHistory.length,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  void _navigateToVaccinationCertificate(GroupedBookingData booking) {
    // Navigate to vaccination certificate screen with booking data
    Get.toNamed(Routes.vaccinationCertificate, arguments: booking);
  }
}

class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader();

  @override
  Widget build(BuildContext context) {
    return const _SectionTitle('Chi tiết các mũi tiêm');
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
