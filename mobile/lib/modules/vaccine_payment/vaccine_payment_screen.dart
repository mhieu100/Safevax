import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vaccine_payment_controller.dart';

class VaccinePaymentScreen extends GetView<VaccinePaymentController> {
  const VaccinePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          'Thanh toán Vaccine',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF199A8E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF199A8E).withOpacity(0.1),
              const Color(0xFFF8FCFC),
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Progress Indicator
                _buildPaymentProgress(),
                const SizedBox(height: 24),

                // Vaccine Summary Card
                _buildVaccineSummaryCard(),
                const SizedBox(height: 24),

                // Payment Options
                _buildPaymentOptions(),
                const SizedBox(height: 24),

                // Security Info
                _buildSecurityInfo(),
                const SizedBox(height: 24),

                // Pay Button
                _buildPayButton(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPaymentProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProgressStep('Chọn vaccine', true),
              _buildProgressConnector(true),
              _buildProgressStep('Thanh toán', true),
              _buildProgressConnector(false),
              _buildProgressStep('Hoàn thành', false),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Bước 2: Chọn phương thức thanh toán',
            style: TextStyle(
              color: Color(0xFF199A8E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String title, bool isCompleted) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isCompleted ? const Color(0xFF199A8E) : Colors.grey.shade300,
            child: Icon(
              isCompleted ? Icons.check : Icons.circle,
              color: isCompleted ? Colors.white : Colors.grey,
              size: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: isCompleted ? const Color(0xFF199A8E) : Colors.grey,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressConnector(bool isActive) {
    return Container(
      width: 20,
      height: 2,
      color: isActive ? const Color(0xFF199A8E) : Colors.grey.shade300,
    );
  }

  Widget _buildVaccineSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF199A8E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.vaccines,
                      color: Color(0xFF199A8E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Thông tin Vaccine",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF199A8E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSummaryRow("Tên Vaccine:", controller.vaccineName.value),
              const SizedBox(height: 8),
              _buildSummaryRow("Liều tiêm:", controller.vaccineDose.value),
              const SizedBox(height: 8),
              _buildSummaryRow(
                "Giá:",
                "${controller.vaccinePrice.value.toString()} VND",
                isPrice: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
            color: isPrice ? Colors.red.shade600 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn phương thức thanh toán",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(
              icon: Icons.account_balance_wallet,
              title: "Ví điện tử",
              subtitle: "Thanh toán nhanh qua MoMo, ZaloPay",
              onTap: () => controller.connectEWallet(),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              icon: Icons.account_balance,
              title: "Chuyển khoản ngân hàng (VnPay)",
              subtitle: "Thanh toán qua Internet Banking",
              onTap: () => controller.bankTransfer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF199A8E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF199A8E),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.verified,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Tất cả giao dịch được bảo mật và ghi nhận trên Blockchain",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
          shadowColor: const Color(0xFF199A8E).withOpacity(0.3),
        ),
        onPressed: () {
          controller.makePayment();
          Get.snackbar(
            'Đang xử lý',
            'Đang thực hiện thanh toán...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.shade50,
            colorText: Colors.blue.shade800,
          );
        },
        icon: const Icon(Icons.payment),
        label: const Text(
          "Thanh toán ngay",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
