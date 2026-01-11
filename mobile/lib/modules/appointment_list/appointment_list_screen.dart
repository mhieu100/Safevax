// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/appointment_list/appointment_list_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';

class AppointmentListScreen extends GetView<AppointmentListController> {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Lịch hẹn tiêm chủng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF2563EB)),
            ),
          );
        }

        return Stack(
          children: [
            // Single scrollable list containing header and appointment cards
            ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 80), // Space for floating elements if needed
              itemCount:
                  controller.filteredAppointments.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header item
                  return _buildHeaderCard();
                } else {
                  // Appointment card item
                  final appointmentIndex = index - 1;
                  final appointment =
                      controller.filteredAppointments[appointmentIndex];
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: _buildAppointmentCard(appointment),
                  );
                }
              },
            ),
          ],
        );
      }),
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
                    Icons.calendar_today,
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
                        'Quản lý Lịch hẹn Tiêm chủng',
                        style: TextStyle(
                          color: const Color(0xFF0D47A1),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Xem và quản lý tất cả lịch hẹn tiêm chủng của bạn với thông tin chi tiết và dễ dàng theo dõi',
                        style: TextStyle(
                          color: const Color(0xFF1565C0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
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
        // Use orange color for text and numbers
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
                        : color.withOpacity(0.05))
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedStatItem(
      String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24.w,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppointmentList() {
    return Obx(() {
      if (controller.filteredAppointments.isEmpty) {
        String statusText = '';
        switch (controller.selectedTab.value) {
          case 'all':
            statusText = 'tất cả';
            break;
          case 'upcoming':
            statusText = controller.getStatusText(AppointmentStatus.upcoming);
            break;
          case 'completed':
            statusText = controller.getStatusText(AppointmentStatus.completed);
            break;
          case 'missed':
            statusText = controller.getStatusText(AppointmentStatus.missed);
            break;
        }
        return Center(
          child: Text(
            'Không có lịch hẹn $statusText',
            style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.filteredAppointments.length,
        itemBuilder: (context, index) {
          return _buildAppointmentCard(controller.filteredAppointments[index]);
        },
      );
    });
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildEnhancedInfoCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16.w,
              color: color,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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

class RescheduleAppointmentDialog extends StatefulWidget {
  final Appointment appointment;

  const RescheduleAppointmentDialog({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  final TextEditingController _reasonController = TextEditingController();
  bool _isProcessingReschedule = false;
  bool _isDatePickerOpen = false;
  late List<TimeOfDay> availableTimeSlots;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.appointment.date;
    availableTimeSlots = const [
      TimeOfDay(hour: 7, minute: 0),
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
    ];
    final appointmentTime = TimeOfDay.fromDateTime(widget.appointment.date);
    // Ensure selectedTime is one of the available slots
    selectedTime = availableTimeSlots.contains(appointmentTime)
        ? appointmentTime
        : availableTimeSlots.first;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Đổi lịch hẹn tiêm",
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

              // Appointment info
              Text(
                "Vaccine: ${widget.appointment.vaccineName}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 8),
              Text(
                "Bác sĩ: ${widget.appointment.doctor}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 12),

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
                    if (_isDatePickerOpen ||
                        _isProcessingReschedule ||
                        !mounted) return;

                    // Set flag to prevent multiple openings
                    setState(() {
                      _isDatePickerOpen = true;
                    });

                    try {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        selectableDayPredicate: (DateTime day) {
                          // Prevent selecting past dates and Sundays
                          return day.isAfter(DateTime.now()
                                  .subtract(const Duration(days: 1))) &&
                              day.weekday != DateTime.sunday;
                        },
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF10B981),
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              dialogTheme: DialogThemeData(
                                  backgroundColor: Colors.white),
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

              // Time selection with dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<TimeOfDay>(
                  value: selectedTime,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  items: availableTimeSlots.map((timeSlot) {
                    return DropdownMenuItem<TimeOfDay>(
                      value: timeSlot,
                      child: Text(
                        formatTime(timeSlot),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (TimeOfDay? newTime) {
                    if (newTime != null) {
                      setState(() {
                        selectedTime = newTime;
                      });
                    }
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
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: "Nhập lý do đổi lịch hẹn...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
                maxLength: 200,
              ),

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

                        // Validate reason is not empty
                        final reason = _reasonController.text.trim();
                        if (reason.isEmpty) {
                          Get.snackbar(
                            "Lỗi",
                            "Vui lòng nhập lý do đổi lịch",
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
                                Get.find<AppointmentListController>();
                            await controller.rescheduleAppointment(
                                widget.appointment, newDateTime, reason);

                            Get.snackbar(
                              "Thành công",
                              "Đã yêu cầu đổi lịch hẹn tiêm",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            Get.snackbar(
                              "Lỗi",
                              "Có lỗi xảy ra khi đổi lịch. Vui lòng thử lại.",
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
                        backgroundColor: const Color(0xFF10B981),
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
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    final timeLabels = {
      'SLOT_07_00': '07:00 - 09:00',
      'SLOT_09_00': '09:00 - 11:00',
      'SLOT_11_00': '11:00 - 13:00',
      'SLOT_13_00': '13:00 - 15:00',
      'SLOT_15_00': '15:00 - 17:00',
    };
    return timeLabels['SLOT_${time.hour.toString().padLeft(2, '0')}_00'] ??
        '${time.hour.toString().padLeft(2, '0')}:00';
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
      AppointmentStatus.cancelled => (Colors.grey, 'Đã hủy'),
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
                        ? Get.find<AppointmentListController>()
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
            if (appointment.status == AppointmentStatus.upcoming)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _AppointmentActions(appointment: appointment),
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

class _AppointmentActions extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentActions({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _rescheduleAppointment(appointment),
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
            onPressed: () => _cancelAppointment(appointment),
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

  void _rescheduleAppointment(Appointment appointment) {
    final controller = Get.find<AppointmentListController>();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: RescheduleAppointmentDialog(appointment: appointment),
      ),
      barrierDismissible: true,
    );
  }

  void _cancelAppointment(Appointment appointment) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận hủy lịch'),
        content: const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final controller = Get.find<AppointmentListController>();
              await controller.cancelAppointment(appointment);
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }
}
