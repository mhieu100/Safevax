import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/shipping_info.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/shipping_info_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/extension/num_ext.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';

class ShippingInfoController extends BaseController<ShippingInfoRepository> {
  ShippingInfoController(super.repository);

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  // Promo code
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final promoDiscount = 0.0.obs;
  final promoError = ''.obs;

  // State dropdown
  final selectedState = ''.obs;
  final List<String> vietnamStates = [
    'An Giang',
    'Bà Rịa - Vũng Tàu',
    'Bắc Giang',
    'Bắc Kạn',
    'Bạc Liêu',
    'Bắc Ninh',
    'Bến Tre',
    'Bình Định',
    'Bình Dương',
    'Bình Phước',
    'Bình Thuận',
    'Cà Mau',
    'Cần Thơ',
    'Cao Bằng',
    'Đà Nẵng',
    'Đắk Lắk',
    'Đắk Nông',
    'Điện Biên',
    'Đồng Nai',
    'Đồng Tháp',
    'Gia Lai',
    'Hà Giang',
    'Hà Nam',
    'Hà Nội',
    'Hà Tĩnh',
    'Hải Dương',
    'Hải Phòng',
    'Hậu Giang',
    'Hòa Bình',
    'Hưng Yên',
    'Khánh Hòa',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lâm Đồng',
    'Lạng Sơn',
    'Lào Cai',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Ninh',
    'Quảng Trị',
    'Sóc Trăng',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'TP Hồ Chí Minh',
    'Trà Vinh',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái'
  ];

  // Form validation
  final firstNameError = ''.obs;
  final lastNameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final streetAddressError = ''.obs;
  final cityError = ''.obs;
  final stateError = ''.obs;
  final zipCodeError = ''.obs;

  // Shipping method selection
  final selectedShippingMethod = 'standard'.obs; // 'standard' or 'express'

  // Order summary data (will be passed from previous screen)
  final RxList<Map<String, dynamic>> orderItems = <Map<String, dynamic>>[].obs;
  final subtotal = 0.0.obs;
  final shippingCost = 0.0.obs;
  final tax = 0.0.obs;
  final total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved shipping info
    _loadSavedShippingInfo();
    // Initialize with sample data
    _initializeOrderData();
    _calculateTotals();
  }

  void _initializeOrderData() {
    orderItems.value = [
      {
        'name': 'STAMARIL phòng bệnh sốt vàng',
        'quantity': 2,
        'price': 2730480, // 5.546.048đ per item
        'image': 'preview_image_url'
      },
      {
        'name': 'Influvac Tetra',
        'quantity': 1,
        'price': 2626107, // 2.626.107đ
        'image': 'preview_image_url'
      }
    ];
  }

  void _calculateTotals() {
    // Calculate subtotal
    double calculatedSubtotal = 0;
    for (var item in orderItems) {
      calculatedSubtotal += (item['price'] as int) * (item['quantity'] as int);
    }
    subtotal.value = calculatedSubtotal;

    // Calculate shipping cost based on method and order value
    // Free shipping for orders over 100,000đ
    if (calculatedSubtotal >= 100000) {
      shippingCost.value = 0.0;
    } else {
      shippingCost.value =
          selectedShippingMethod.value == 'express' ? 15.99 : 0.0;
    }

    // Calculate tax (8.25% as example)
    tax.value = (subtotal.value + shippingCost.value) * 0.0825;

    // Apply promo discount
    double discount = promoDiscount.value;

    // Calculate total
    total.value = subtotal.value + shippingCost.value + tax.value - discount;
  }

  void selectShippingMethod(String method) {
    selectedShippingMethod.value = method;
    _calculateTotals();
  }

  String formatCurrency(double amount) {
    return '${amount.formatNumber()}đ';
  }

  String formatCurrencyUSD(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  bool validateForm() {
    bool isValid = true;

    // Validate first name
    if (firstNameController.text.trim().isEmpty) {
      firstNameError.value = 'Họ là bắt buộc';
      isValid = false;
    } else {
      firstNameError.value = '';
    }

    // Validate last name
    if (lastNameController.text.trim().isEmpty) {
      lastNameError.value = 'Tên là bắt buộc';
      isValid = false;
    } else {
      lastNameError.value = '';
    }

    // Validate email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email là bắt buộc';
      isValid = false;
    } else if (!emailRegex.hasMatch(emailController.text.trim())) {
      emailError.value = 'Vui lòng nhập email hợp lệ';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Validate phone
    final phoneRegex = RegExp(r'^\d{10,11}$');
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Số điện thoại là bắt buộc';
      isValid = false;
    } else if (!phoneRegex.hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Vui lòng nhập số điện thoại hợp lệ';
      isValid = false;
    } else {
      phoneError.value = '';
    }

    // Validate street address
    if (streetAddressController.text.trim().isEmpty) {
      streetAddressError.value = 'Địa chỉ là bắt buộc';
      isValid = false;
    } else {
      streetAddressError.value = '';
    }

    // Validate city
    if (cityController.text.trim().isEmpty) {
      cityError.value = 'Thành phố là bắt buộc';
      isValid = false;
    } else {
      cityError.value = '';
    }

    // Validate ZIP code
    final zipRegex = RegExp(r'^\d{5,6}$');
    if (zipCodeController.text.trim().isEmpty) {
      zipCodeError.value = 'Mã bưu điện là bắt buộc';
      isValid = false;
    } else if (!zipRegex.hasMatch(zipCodeController.text.trim())) {
      zipCodeError.value = 'Vui lòng nhập mã bưu điện hợp lệ';
      isValid = false;
    } else {
      zipCodeError.value = '';
    }

    return isValid;
  }

  void applyPromoCode() {
    final code = promoCodeController.text.trim().toUpperCase();
    promoError.value = '';

    // Simple promo code logic - you can extend this
    if (code == 'SAVE10') {
      promoDiscount.value = subtotal.value * 0.1; // 10% discount
      appliedPromoCode.value = code;
      promoCodeController.clear();
      _calculateTotals();
      Get.snackbar(
        'Thành công',
        'Đã áp dụng mã giảm giá! Giảm 10%.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else if (code == 'FREE20') {
      promoDiscount.value = 20.0; // Fixed $20 discount
      appliedPromoCode.value = code;
      promoCodeController.clear();
      _calculateTotals();
      Get.snackbar(
        'Thành công',
        'Đã áp dụng mã giảm giá! Giảm 20.000đ.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else if (code.isNotEmpty) {
      promoError.value = 'Invalid promo code';
      Get.snackbar(
        'Lỗi',
        'Mã giảm giá không hợp lệ. Thử SAVE10 hoặc FREE20.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    promoDiscount.value = 0.0;
    promoError.value = '';
    _calculateTotals();
  }

  void _loadSavedShippingInfo() {
    try {
      final savedData = StorageService.patientProfileData;
      if (savedData != null && savedData.containsKey('shipping_info')) {
        final shippingData = savedData['shipping_info'];
        if (shippingData != null) {
          final shippingInfo = ShippingInfo.fromJson(shippingData);
          firstNameController.text = shippingInfo.firstName;
          lastNameController.text = shippingInfo.lastName;
          emailController.text = shippingInfo.email;
          phoneController.text = shippingInfo.phone;
          streetAddressController.text = shippingInfo.streetAddress;
          cityController.text = shippingInfo.city;
          selectedState.value = shippingInfo.state ?? '';
          zipCodeController.text = shippingInfo.zipCode;
        }
      }
    } catch (e) {
      // Handle error silently, use empty form
    }
  }

  void _saveShippingInfo() {
    try {
      final shippingInfo = ShippingInfo(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        streetAddress: streetAddressController.text.trim(),
        city: cityController.text.trim(),
        state: selectedState.value.isNotEmpty ? selectedState.value : null,
        zipCode: zipCodeController.text.trim(),
      );
      // Get existing profile data and update shipping info
      final existingData = StorageService.patientProfileData ?? {};
      existingData['shipping_info'] = shippingInfo.toJson();
      StorageService.patientProfileData = existingData;
    } catch (e) {
      // Handle error silently
    }
  }

  void proceedToPayment() {
    if (validateForm()) {
      // Save shipping info locally
      _saveShippingInfo();

      // For now, just show success message
      // In the future, this will navigate to payment screen
      Get.snackbar(
        'Thành công',
        'Thông tin giao hàng đã được lưu thành công!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Lỗi xác thực',
        'Vui lòng điền đầy đủ tất cả các trường bắt buộc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    promoCodeController.dispose();
    super.onClose();
  }
}
