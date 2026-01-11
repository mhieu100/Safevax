// lib/modules/booking_summary/booking_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/booking_summary/booking_summary_controller.dart';
import 'package:flutter_getx_boilerplate/shared/extension/num_ext.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingSummaryScreen extends GetView<BookingSummaryController> {
  const BookingSummaryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Tóm tắt Đơn hàng',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        elevation: 0.5,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vaccine Information Card - Hiển thị tất cả vaccine
                  _buildVaccineCard(controller.bookingSummary.vaccines),
                  const SizedBox(height: 12),

                  // Vaccination Schedule Card - Hiển thị lịch tiêm chi tiết
                  _buildDetailedScheduleCard(controller.bookingSummary),
                  const SizedBox(height: 12),

                  // Payment Methods Card
                  _buildPaymentMethodsCard(),
                  const SizedBox(height: 12),

                  // Price Breakdown Card
                  _buildPriceBreakdownCard(controller.bookingSummary.vaccines,
                      controller.bookingSummary.totalPrice),
                ],
              ),
            ),
          ),

          // Bottom Checkout Bar
          _buildBottomCheckoutBar(controller.bookingSummary.totalPrice),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(List<VaccineModel> vaccines) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin Vaccine',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 12),
          ...vaccines.map((vaccine) => _buildVaccineItem(vaccine)),
        ],
      ),
    );
  }

  Widget _buildVaccineItem(VaccineModel vaccine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF8FAFC),
            ),
            child: vaccine.imageUrl.isNotEmpty
                ? Image.network(vaccine.imageUrl, fit: BoxFit.cover)
                : const Icon(Icons.medical_services,
                    size: 30, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  vaccine.manufacturer,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${vaccine.price.formatNumber()}₫',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedScheduleCard(VaccineBooking booking) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch Tiêm chủng Chi tiết',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 12),

          // Hiển thị từng vaccine với lịch tiêm của nó
          ...booking.vaccines.map((vaccine) =>
              _buildVaccineScheduleSection(vaccine, booking, dateFormat)),
        ],
      ),
    );
  }

  Widget _buildVaccineScheduleSection(
      VaccineModel vaccine, VaccineBooking booking, DateFormat dateFormat) {
    // Lấy tất cả dose bookings cho vaccine này
    final vaccineDoses = booking.doseBookings.entries
        .where((entry) =>
            controller.isDoseForVaccine(entry.key, vaccine, booking.vaccines))
        .toList();

    if (vaccineDoses.isEmpty) return const SizedBox.shrink();

    // Sắp xếp theo dose number và lấy mũi đầu tiên
    vaccineDoses.sort((a, b) => a.key.compareTo(b.key));
    final firstDose = vaccineDoses.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header vaccine
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.medical_services,
                  size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vaccine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Hiển thị lịch tiêm cho vaccine này (chỉ mũi đầu tiên)
        _buildScheduleItemDetailed(
          dateFormat.format(firstDose.value.dateTime),
          firstDose.value.facility,
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScheduleItemDetailed(
      String dateTime, HealthcareFacility facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: [
          // Thông tin ngày giờ tiêm
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 20, color: Color(0xFF3B82F6)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Thông tin cơ sở tiêm chủng
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: Color(0xFF3B82F6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        facility.address,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 10, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            facility.phone,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseItemDetailed(String doseName, String dateTime,
      HealthcareFacility facility, String intervalInfo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: [
          // Thông tin mũi tiêm
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    doseName.replaceAll('Mũi ', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doseName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dateTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      intervalInfo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.calendar_today,
                  size: 16, color: Color(0xFF3B82F6)),
            ],
          ),
          const SizedBox(height: 8),

          // Thông tin cơ sở tiêm chủng
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: Color(0xFF3B82F6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        facility.address,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 10, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            facility.phone,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    final paymentMethods = [
      {
        'title': 'Thanh toán ví điện tử (PayPal)',
        'icon': Icons.wallet,
        'color': const Color(0xFFFF6B35),
        'enabled': true
      },
      {
        'title': 'Chuyển khoản ngân hàng (VnPay)',
        'icon': Icons.account_balance,
        'color': const Color(0xFF3B82F6),
        'enabled': true
      },
      {
        'title': 'Thanh toán khi tiêm',
        'icon': Icons.local_hospital,
        'color': const Color(0xFF10B981),
        'enabled': true
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức Thanh toán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 12),
          ...paymentMethods.map((method) => _buildPaymentMethodItem(
                method['title'] as String,
                method['icon'] as IconData,
                method['color'] as Color,
                method['enabled'] as bool,
              )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(
      String title, IconData icon, Color color, bool enabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Obx(() => controller.selectedPaymentMethod == title
            ? const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20)
            : const Icon(Icons.radio_button_unchecked,
                color: Colors.grey, size: 20)),
        onTap: enabled
            ? () {
                controller.selectPaymentMethod(title);
              }
            : () {
                Get.snackbar(
                  'Thông báo',
                  'Tính năng này đang được phát triển',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFF6366F1).withOpacity(0.9),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                );
              },
      ),
    );
  }

  Widget _buildPriceBreakdownCard(
      List<VaccineModel> vaccines, double totalPrice) {
    double totalDosesPrice = 0;
    double totalDiscount = 0;

    // Calculate based on vaccine quantities from booking
    final vaccineQuantities = controller.bookingSummary.vaccineQuantities;

    for (var vaccine in vaccines) {
      final quantity = vaccineQuantities[vaccine.id] ?? 1;
      totalDosesPrice += vaccine.price * quantity;
      if (vaccine.originalPrice != null) {
        totalDiscount += (vaccine.originalPrice! - vaccine.price) * quantity;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Show price for each vaccine
          ...vaccines.map((vaccine) => Column(
                children: [
                  _buildPriceRow(
                      '${vaccine.name} (x ${controller.bookingSummary.vaccineQuantities[vaccine.id] ?? 1})',
                      '${(vaccine.price * (controller.bookingSummary.vaccineQuantities[vaccine.id] ?? 1)).formatNumber()}₫'),
                  const SizedBox(height: 4),
                ],
              )),

          const SizedBox(height: 8),
          if (totalDiscount > 0)
            Column(
              children: [
                _buildPriceRow('Giảm giá', '-${totalDiscount.formatNumber()}₫',
                    isDiscount: true),
                const SizedBox(height: 8),
              ],
            ),
          _buildPriceRow('Phí dịch vụ', '0₫'),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Tổng cộng',
            '${totalPrice.formatNumber()}₫',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? const Color(0xFF10B981) : Colors.grey[700],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isTotal
                ? const Color(0xFFEF4444)
                : isDiscount
                    ? const Color(0xFF10B981)
                    : Colors.grey[700],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCheckoutBar(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${totalPrice.formatNumber()}₫',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Obx(() => ElevatedButton(
                  onPressed: (controller.selectedPaymentMethod?.isEmpty ?? true)
                      ? null
                      : controller.processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.buttontGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
