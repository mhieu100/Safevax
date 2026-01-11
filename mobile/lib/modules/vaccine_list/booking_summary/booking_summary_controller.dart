import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/booking_summary_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/services/payment_service.dart';
import 'package:flutter_getx_boilerplate/constants/paypal_constants.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/models/request/booking_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';

class BookingSummaryController
    extends BaseController<BookingSummaryRepository> {
  BookingSummaryController(super.repository);
  VaccineBooking bookingSummary = VaccineBooking(
    id: '',
    userId: '',
    vaccines: [],
    vaccineQuantities: {},
    bookingDate: DateTime.now(),
    doseBookings: {},
    totalPrice: 0,
    createdAt: DateTime.now(),
  );
  final RxString _selectedPaymentMethod = RxString('');
  final RxBool _isLoading = false.obs;

  String? get selectedPaymentMethod => _selectedPaymentMethod.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Any initialization logic
    final args = Get.arguments;
    if (args is Map && args['booking'] is VaccineBooking) {
      bookingSummary = args['booking'] as VaccineBooking;
      // Always recalculate total price to ensure it's correct
      bookingSummary = bookingSummary.copyWith(
        totalPrice: _calculateTotalPrice(bookingSummary),
      );
    }
  }

  double _calculateTotalPrice(VaccineBooking booking) {
    double total = 0;
    for (final vaccine in booking.vaccines) {
      final quantity = booking.vaccineQuantities[vaccine.id] ?? 1;
      total += vaccine.price *
          quantity; // Only multiply by quantity, not by numberOfDoses
    }
    return total;
  }

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod.value = method;
  }

  void processPayment() {
    if (_selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn phương thức thanh toán',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_isLoading.value) return; // Prevent multiple calls

    // Handle PayPal payment differently
    if (_selectedPaymentMethod.value == 'Thanh toán ví điện tử (PayPal)') {
      _processPayPalPayment();
    } else if (_selectedPaymentMethod.value ==
        'Chuyển khoản ngân hàng (VnPay)') {
      _processVNPayPayment();
    } else {
      _showPaymentConfirmation();
    }
  }

  void _processPayPalPayment() async {
    _isLoading.value = true;

    try {
      // First, create the booking
      print('📝 [PayPal] Creating booking first...');
      final bookingData = _prepareBookingDataNew();
      final bookingResponse = await repository.createBookingNew(bookingData);
      print('✅ [PayPal] Booking created: ${bookingResponse['referenceId']}');

      // Check if PayPal is configured with valid credentials
      final clientId = PayPalConfig.clientId;
      final clientSecret = PayPalConfig.clientSecret;

      if (clientId.isEmpty ||
          clientSecret.isEmpty ||
          clientId == 'your_paypal_client_id' ||
          clientSecret == 'your_paypal_client_secret') {
        print(
            '⚠️ [PayPal] PayPal not configured - missing or placeholder client credentials');
        print('🔧 [PayPal] Current clientId: $clientId');
        print(
            '🔧 [PayPal] Current clientSecret: ${clientSecret.isNotEmpty ? "***" : "empty"}');
        _showPayPalNotConfiguredError();
        return;
      }

      // Prepare cart items for PayPal order
      final cartItems = _prepareCartItemsForPayPal();
      print('🔄 [PayPal] Preparing cart items: $cartItems');
      print('💰 [PayPal] Total amount: ${bookingSummary.totalPrice}');

      // Create PayPal order via frontend PayPal API
      print('📡 [PayPal] Creating PayPal order via frontend API');
      final orderResponse = await PaymentService.createPayPalOrder(
        items: cartItems,
        totalAmount: bookingSummary.totalPrice,
      );

      print('📨 [PayPal] Order response: $orderResponse');

      if (orderResponse['statusCode'] == 200) {
        final paymentUrl = orderResponse['data']['paymentURL'];
        print('🔗 [PayPal] Payment URL received: $paymentUrl');

        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          // Open PayPal checkout in external browser
          print('🌐 [PayPal] Opening PayPal checkout in external browser');
          await _launchPayPalCheckout(paymentUrl);
        } else {
          print('❌ [PayPal] Payment URL is null or empty');
          _showError('Không thể lấy URL thanh toán PayPal');
        }
      } else {
        print('❌ [PayPal] Order creation failed: ${orderResponse['message']}');
        _showError(orderResponse['message'] ?? 'Không thể tạo đơn hàng PayPal');
      }
    } catch (e, stackTrace) {
      print('💥 [PayPal] Exception in _processPayPalPayment: $e');
      print('📚 [PayPal] Stack trace: $stackTrace');

      // Get the actual error message
      String errorText = e is ErrorResponse ? e.message : e.toString();

      // Translate error message to Vietnamese
      String errorMessage = _translateErrorMessage(errorText);

      // Check if it's a configuration error
      if (e.toString().contains('PayPal') &&
          e.toString().contains('not configured')) {
        _showPayPalNotConfiguredError();
      } else {
        _showError(errorMessage);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void _showPayPalNotConfiguredError() {
    Get.dialog(
      AlertDialog(
        title: const Text('PayPal chưa được cấu hình'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PayPal chưa được cấu hình với thông tin hợp lệ.'),
            SizedBox(height: 8),
            Text('Để kích hoạt PayPal, bạn cần:'),
            SizedBox(height: 4),
            Text('• Tạo tài khoản PayPal Business'),
            Text('• Tạo REST API app trên PayPal Developer'),
            Text(
                '• Cập nhật PAYPAL_CLIENT_ID và PAYPAL_CLIENT_SECRET trong file .env'),
            SizedBox(height: 8),
            Text('Hoặc chọn phương thức thanh toán khác.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Auto-select cash payment
              selectPaymentMethod('Thanh toán khi tiêm');
              processPayment();
            },
            child: const Text('Thanh toán khi tiêm'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _prepareCartItemsForPayPal() {
    return bookingSummary.vaccines.map((vaccine) {
      final quantity = bookingSummary.vaccineQuantities[vaccine.id] ?? 1;
      return {
        'id': vaccine.id,
        'quantity': quantity,
      };
    }).toList();
  }

  Future<void> _launchPayPalCheckout(String paymentUrl) async {
    try {
      print('🔗 [PayPal] Parsing payment URL: $paymentUrl');
      final Uri url = Uri.parse(paymentUrl);

      print('🔍 [PayPal] Checking if URL can be launched: ${url.toString()}');
      if (await canLaunchUrl(url)) {
        print('✅ [PayPal] URL can be launched, opening in external browser');
        await launchUrl(url, mode: LaunchMode.externalApplication);
        print('🎯 [PayPal] PayPal checkout opened successfully');

        Get.snackbar(
          'Thông báo',
          'Đang mở PayPal để thanh toán...',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        print('❌ [PayPal] URL cannot be launched: ${url.toString()}');
        _showError('Không thể mở PayPal. Vui lòng thử lại.');
      }
    } catch (e, stackTrace) {
      print('💥 [PayPal] Exception in _launchPayPalCheckout: $e');
      print('📚 [PayPal] Stack trace: $stackTrace');
      _showError('Lỗi mở PayPal: $e');
    }
  }

  void _processVNPayPayment() async {
    _isLoading.value = true;

    try {
      // First, create the booking
      print('📝 [VNPay] Creating booking first...');
      final bookingData = _prepareBookingDataNew();
      final bookingResponse = await repository.createBookingNew(bookingData);
      print('✅ [VNPay] Booking created: ${bookingResponse['referenceId']}');

      // Get the payment URL from the booking response
      final paymentUrl = bookingResponse['paymentURL'];
      print('🔗 [VNPay] Payment URL from backend: $paymentUrl');

      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        // Open VNPay checkout in external browser
        print('🌐 [VNPay] Opening VNPay checkout in external browser');
        await _launchVNPayCheckout(paymentUrl);
      } else {
        print('❌ [VNPay] Payment URL is null or empty');
        _showError('Không thể lấy URL thanh toán VNPay từ backend');
      }
    } catch (e, stackTrace) {
      print('💥 [VNPay] Exception in _processVNPayPayment: $e');
      print('📚 [VNPay] Stack trace: $stackTrace');

      // Check if it's an authentication error (401)
      if (e.toString().contains('401') ||
          e.toString().contains('Token không hợp lệ')) {
        print('🔐 [VNPay] Authentication error detected, handling logout');
        await PaymentService.handleAuthError();
      } else {
        // Get the actual error message
        String errorText = e is ErrorResponse ? e.message : e.toString();

        // Translate error message to Vietnamese
        String errorMessage = _translateErrorMessage(errorText);

        _showError(errorMessage);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _launchVNPayCheckout(String paymentUrl) async {
    try {
      print('🔗 [VNPay] Parsing payment URL: $paymentUrl');
      final Uri url = Uri.parse(paymentUrl);

      print('🔍 [VNPay] Checking if URL can be launched: ${url.toString()}');
      if (await canLaunchUrl(url)) {
        print('✅ [VNPay] URL can be launched, opening in external browser');
        await launchUrl(url, mode: LaunchMode.externalApplication);
        print('🎯 [VNPay] VNPay checkout opened successfully');

        Get.snackbar(
          'Thông báo',
          'Đang mở VNPay để thanh toán...',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        print(
            '❌ [VNPay] URL cannot be launched with external browser, trying in-app webview');
        // Try with in-app webview as fallback
        try {
          await launchUrl(url, mode: LaunchMode.inAppWebView);
          print('🎯 [VNPay] VNPay checkout opened in in-app webview');

          Get.snackbar(
            'Thông báo',
            'Đang mở VNPay để thanh toán...',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } catch (fallbackError) {
          print('❌ [VNPay] Fallback also failed: $fallbackError');
          _showError(
              'Không thể mở VNPay. Vui lòng kiểm tra kết nối internet và thử lại.');
        }
      }
    } catch (e, stackTrace) {
      print('💥 [VNPay] Exception in _launchVNPayCheckout: $e');
      print('📚 [VNPay] Stack trace: $stackTrace');
      _showError('Lỗi mở VNPay: $e');
    }
  }

  void _showError(String message) {
    print('🚨 [Payment] Showing user error: $message');

    Get.snackbar(
      'Lỗi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  void _showPaymentConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận Thanh toán'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bạn có chắc chắn muốn thanh toán bằng'),
            Text(
              _selectedPaymentMethod.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('?'),
            if (_isLoading.value) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Đang xử lý...'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading.value ? null : () => Get.back(),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _isLoading.value ? null : _completeBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _completeBooking() async {
    Get.back(); // Close dialog

    _isLoading.value = true;

    try {
      // Prepare booking data for new API
      final bookingData = _prepareBookingDataNew();

      // Call new API to create booking
      final bookingResponse = await repository.createBookingNew(bookingData);

      // Update booking with payment method and confirmation code
      final completedBooking = VaccineBooking(
        id: bookingResponse['referenceId']?.toString() ?? bookingSummary.id,
        userId: bookingSummary.userId,
        vaccines: bookingSummary.vaccines,
        bookingDate: bookingSummary.bookingDate,
        doseBookings: bookingSummary.doseBookings,
        totalPrice:
            _calculateTotalPrice(bookingSummary), // Ensure correct total price
        status: 'confirmed',
        paymentMethod: _selectedPaymentMethod.value,
        confirmationCode: bookingSummary.confirmationCode ??
            'VAC-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        createdAt: bookingSummary.createdAt,
        updatedAt: DateTime.now(),
        vaccineQuantities: bookingSummary.vaccineQuantities,
      );

      // Navigate to payment success screen
      NavigatorHelper.toPaymentSuccessScreen(
        booking: completedBooking,
      );

      // Don't show success snackbar, just navigate to payment success
    } catch (e) {
      // Get the actual error message
      String errorText = e is ErrorResponse ? e.message : e.toString();

      // Translate error message to Vietnamese
      String errorMessage = _translateErrorMessage(errorText);

      Get.dialog(
        AlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  String _mapPaymentMethod(String selectedMethod) {
    switch (selectedMethod) {
      case 'Thanh toán ví điện tử (PayPal)':
        return 'PAYPAL';
      case 'Chuyển khoản ngân hàng (VnPay)':
        return 'BANK';
      case 'Thanh toán khi tiêm':
        return 'CASH';
      default:
        return 'CASH';
    }
  }

  Map<String, dynamic> _prepareBookingData() {
    // Get the first vaccine and center for the booking
    final firstVaccine = bookingSummary.vaccines.isNotEmpty
        ? bookingSummary.vaccines.first
        : null;
    final firstDoseBooking = bookingSummary.doseBookings.values.isNotEmpty
        ? bookingSummary.doseBookings.values.first
        : null;

    if (firstVaccine == null || firstDoseBooking == null) {
      throw Exception('Invalid booking data');
    }

    // Prepare dose schedules
    final doseSchedules = <Map<String, dynamic>>[];
    for (final doseBooking in bookingSummary.doseBookings.values) {
      if (doseBooking.doseNumber > 1) {
        // Only add subsequent doses
        doseSchedules.add({
          'date': _formatDate(doseBooking.dateTime),
          'time': _formatTime(doseBooking.dateTime),
          'centerId': int.tryParse(doseBooking.facility.id) ?? 0,
        });
      }
    }

    return {
      'vaccineId': int.tryParse(firstVaccine.id) ?? 0,
      'centerId': int.tryParse(firstDoseBooking.facility.id) ?? 0,
      'firstDoseDate': _formatDate(firstDoseBooking.dateTime),
      'firstDoseTime': _formatTime(firstDoseBooking.dateTime),
      'amount': bookingSummary.totalPrice.toInt(),
      'doseSchedules': doseSchedules,
      'paymentMethod': _mapPaymentMethod(_selectedPaymentMethod.value),
    };
  }

  Map<String, dynamic> _prepareBookingDataNew() {
    // Get the first vaccine and center for the booking
    final firstVaccine = bookingSummary.vaccines.isNotEmpty
        ? bookingSummary.vaccines.first
        : null;
    final firstDoseBooking = bookingSummary.doseBookings.values.isNotEmpty
        ? bookingSummary.doseBookings.values.first
        : null;

    if (firstVaccine == null || firstDoseBooking == null) {
      throw Exception('Invalid booking data');
    }

    return {
      'vaccineId': int.tryParse(firstVaccine.id) ?? 0,
      'familyMemberId': bookingSummary.familyMemberId != null
          ? int.tryParse(bookingSummary.familyMemberId!)
          : null,
      'appointmentDate': _formatDate(firstDoseBooking.dateTime),
      'appointmentTime': _formatTime(firstDoseBooking.dateTime),
      'appointmentCenter': int.tryParse(firstDoseBooking.facility.id) ?? 0,
      'amount': bookingSummary.totalPrice.toInt(),
      'paymentMethod': _mapPaymentMethod(_selectedPaymentMethod.value),
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  BookingRequest _prepareBookingRequest() {
    // Prepare dose bookings
    final doseBookings = <int, DoseBookingRequest>{};
    for (final entry in bookingSummary.doseBookings.entries) {
      final doseBooking = entry.value;
      doseBookings[entry.key] = DoseBookingRequest(
        doseNumber: doseBooking.doseNumber,
        dateTime: doseBooking.dateTime,
        facilityId: doseBooking.facility.id,
        vaccineId: doseBooking.vaccineId,
        vaccineDoseNumber: doseBooking.vaccineDoseNumber,
      );
    }

    return BookingRequest(
      userId: bookingSummary.userId,
      vaccineIds: bookingSummary.vaccines.map((v) => v.id).toList(),
      vaccineQuantities: bookingSummary.vaccineQuantities,
      bookingDate: bookingSummary.bookingDate,
      doseBookings: doseBookings,
      paymentMethod: _selectedPaymentMethod.value.isNotEmpty
          ? _selectedPaymentMethod.value
          : null,
    );
  }

  // Helper methods for vaccine dose calculations
  bool isDoseForVaccine(
      int doseKey, VaccineModel vaccine, List<VaccineModel> allVaccines) {
    int currentDoseCount = 0;
    for (final v in allVaccines) {
      if (v == vaccine) {
        final startDose = currentDoseCount + 1;
        final endDose = currentDoseCount + v.numberOfDoses;
        return doseKey >= startDose && doseKey <= endDose;
      }
      currentDoseCount += v.numberOfDoses;
    }
    return false;
  }

  int getVaccineDoseNumber(
      int doseKey, VaccineModel vaccine, List<VaccineModel> allVaccines) {
    int currentDoseCount = 0;
    for (final v in allVaccines) {
      if (v == vaccine) {
        return doseKey - currentDoseCount;
      }
      currentDoseCount += v.numberOfDoses;
    }
    return doseKey;
  }

  String getDoseIntervalInfo(
      int doseKey, VaccineModel vaccine, List<VaccineModel> allVaccines) {
    final doseNumber = getVaccineDoseNumber(doseKey, vaccine, allVaccines);
    if (doseNumber == 1) {
      return 'Mũi đầu tiên';
    }

    if (vaccine.schedule.length >= doseNumber) {
      final interval = vaccine.schedule[doseNumber - 1].getDaysInterval();
      return 'Sau mũi ${doseNumber - 1} là $interval ngày';
    }

    return 'Sau mũi ${doseNumber - 1}';
  }

  String _translateErrorMessage(String error) {
    // Handle specific API error messages
    if (error.contains(
        'You already have an active appointment for this vaccination course.')) {
      return 'Bạn đã lên lịch tiêm chủng này rồi. Vui lòng kiểm tra lịch hẹn của bạn.';
    }

    // Handle other common errors
    if (error.contains('400')) {
      return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin đặt lịch.';
    }

    if (error.contains('401')) {
      return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    }

    if (error.contains('500')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    }

    // For specific API errors like 'Vaccine is out of stock!', show as is
    // Default error message
    return error;
  }
}
