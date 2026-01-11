import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethod {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDefault;
  final String type; // 'card', 'bank', 'ewallet', etc.

  PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isDefault = false,
    required this.type,
  });
}

class PaymentMethodsController extends GetxController {
  final paymentMethods = <PaymentMethod>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }

  void loadPaymentMethods() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    paymentMethods.value = [
      PaymentMethod(
        id: '1',
        title: 'Thẻ tín dụng Visa',
        subtitle: '**** **** **** 1234',
        icon: Icons.credit_card,
        color: Colors.blue,
        isDefault: true,
        type: 'card',
      ),
      PaymentMethod(
        id: '2',
        title: 'Ví điện tử MoMo',
        subtitle: 'Số dư: 500,000 VND',
        icon: Icons.account_balance_wallet,
        color: Colors.pink,
        type: 'ewallet',
      ),
      PaymentMethod(
        id: '3',
        title: 'Ngân hàng Vietcombank',
        subtitle: 'TK: *******123',
        icon: Icons.account_balance,
        color: Colors.green,
        type: 'bank',
      ),
      PaymentMethod(
        id: '4',
        title: 'Thẻ ghi nợ Mastercard',
        subtitle: '**** **** **** 5678',
        icon: Icons.credit_card,
        color: Colors.orange,
        type: 'card',
      ),
    ];

    isLoading.value = false;
  }

  void addNewPaymentMethod() {
    Get.snackbar(
      'Thông báo',
      'Tính năng thêm phương thức thanh toán đang được phát triển!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectPaymentMethod(PaymentMethod method) {
    Get.snackbar(
      'Đã chọn',
      'Đã chọn phương thức: ${method.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void handleMenuAction(String action, PaymentMethod method) {
    switch (action) {
      case 'set_default':
        setAsDefault(method);
        break;
      case 'edit':
        editPaymentMethod(method);
        break;
      case 'delete':
        deletePaymentMethod(method);
        break;
    }
  }

  void setAsDefault(PaymentMethod method) {
    // Update all methods to not be default
    for (var m in paymentMethods) {
      m = PaymentMethod(
        id: m.id,
        title: m.title,
        subtitle: m.subtitle,
        icon: m.icon,
        color: m.color,
        isDefault: false,
        type: m.type,
      );
    }

    // Set the selected method as default
    final index = paymentMethods.indexWhere((m) => m.id == method.id);
    if (index != -1) {
      paymentMethods[index] = PaymentMethod(
        id: method.id,
        title: method.title,
        subtitle: method.subtitle,
        icon: method.icon,
        color: method.color,
        isDefault: true,
        type: method.type,
      );
      paymentMethods.refresh();
    }

    Get.snackbar(
      'Thành công',
      'Đã đặt ${method.title} làm phương thức mặc định',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editPaymentMethod(PaymentMethod method) {
    Get.snackbar(
      'Thông báo',
      'Tính năng chỉnh sửa phương thức thanh toán đang được phát triển!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deletePaymentMethod(PaymentMethod method) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa phương thức "${method.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              paymentMethods.remove(method);
              Get.snackbar(
                'Đã xóa',
                'Đã xóa phương thức thanh toán',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}