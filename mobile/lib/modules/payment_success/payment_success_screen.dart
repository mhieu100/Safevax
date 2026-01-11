// lib/modules/payment_success/payment_success_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/payment_success/payment_success_controller.dart';
import 'package:flutter_getx_boilerplate/shared/extension/num_ext.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends GetView<PaymentSuccessController> {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: controller.goToHome,
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading
            ? _buildLoadingIndicator()
            : SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 60.w,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Success Title
                    Text(
                      'Thanh toán thành công!',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1F36),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Success Message
                    Text(
                      'Đơn đặt lịch tiêm chủng của bạn đã được xác nhận',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    _buildNotificationStatus(),
                    SizedBox(height: 16.h),

                    // Confirmation Card
                    _buildConfirmationCard(),
                    SizedBox(height: 24.h),

                    // Vaccine Information
                    _buildVaccineInfoCard(),
                    SizedBox(height: 24.h),

                    // Next Steps
                    _buildNextStepsCard(),
                    SizedBox(height: 24.h),

                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
      ),
    );
  }

// Thêm các widget mới
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
          SizedBox(height: 16.h),
          Text(
            'Đang gửi thông báo xác nhận...',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStatus() {
    return Obx(() => controller.notificationsSent
        ? Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    color: const Color(0xFF10B981), size: 20.w),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Đã gửi thông báo xác nhận qua email và SMS',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.resendNotifications,
                  child: Text(
                    'Gửi lại',
                    style: const TextStyle(color: Color(0xFF3B82F6)),
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: const Color(0xFFF59E0B), size: 20.w),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Đang gửi thông báo xác nhận...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  Widget _buildConfirmationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const Text(
            'Thông tin đặt lịch',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
              'Ngày đặt lịch',
              DateFormat('dd/MM/yyyy - HH:mm')
                  .format(controller.booking.bookingDate)),
          const SizedBox(height: 12),
          _buildInfoRow('Phương thức thanh toán',
              controller.booking.paymentMethod ?? 'Chưa xác định'),
          const SizedBox(height: 12),
          _buildInfoRow('Tổng thanh toán',
              '${controller.booking.totalPrice.formatNumber()}₫',
              isPrice: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isPrice ? const Color(0xFFEF4444) : const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin tiêm chủng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 16),

          ...controller.booking.vaccines
              .map((vaccine) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              vaccine.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          '${vaccine.numberOfDoses} mũi • ${vaccine.manufacturer}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ))
              .toList(),

          // Hiển thị lịch tiêm đầu tiên
          if (controller.booking.doseBookings.isNotEmpty &&
              controller.booking.doseBookings.containsKey(1) &&
              controller.booking.doseBookings[1] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Lịch hẹn đầu tiên:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildScheduleItem(
                  Icons.calendar_today,
                  '${DateFormat('dd/MM/yyyy').format(controller.booking.doseBookings[1]!.dateTime)} '
                  'lúc ${DateFormat('HH:mm').format(controller.booking.doseBookings[1]!.dateTime)}',
                ),
                const SizedBox(height: 8),
                _buildScheduleItem(
                  Icons.location_on,
                  controller.booking.doseBookings[1]!.facility.name,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    controller.booking.doseBookings[1]!.facility.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Hướng dẫn tiếp theo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            icon: Icons.notifications_active,
            title: 'Thông báo nhắc lịch',
            description: 'Hệ thống sẽ gửi thông báo trước 24h và 2h',
          ),
          const SizedBox(height: 12),
          _buildStepItem(
            icon: Icons.qr_code_scanner,
            title: 'Mang theo mã QR',
            description: 'Xuất trình mã QR khi đến cơ sở tiêm chủng',
          ),
          const SizedBox(height: 12),
          _buildStepItem(
            icon: Icons.access_time,
            title: 'Đến sớm 15 phút',
            description: 'Có mặt trước giờ hẹn để làm thủ tục',
          ),
          const SizedBox(height: 12),
          _buildStepItem(
            icon: Icons.medical_services,
            title: 'Mang theo giấy tờ',
            description: 'CMND/CCCD và sổ tiêm chủng (nếu có)',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFF59E0B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF92400E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.goToHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Về trang chủ'),
          ),
        ),
      ],
    );
  }
}
