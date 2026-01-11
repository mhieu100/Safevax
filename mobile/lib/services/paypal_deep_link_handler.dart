import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/payment_success_screen.dart';
import '../screens/payment_cancelled_screen.dart';
import '../screens/payment_error_screen.dart';

class PayPalDeepLinkHandler {
  static void handleDeepLink(Uri uri) async {
    try {
      print('🔗 [DeepLink] Received deep link: ${uri.toString()}');
      print(
          '📋 [DeepLink] Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');
      print('🔍 [DeepLink] Query parameters: ${uri.queryParameters}');

      if (uri.scheme == 'yourapp' && uri.host == 'paypal') {
        final path = uri.path;
        final queryParams = uri.queryParameters;

        if (path == '/success') {
          print('✅ [DeepLink] Processing successful PayPal payment callback');

          // Handle successful PayPal payment
          final paymentId = queryParams['token'];
          final payerId = queryParams['PayerID'];

          print('💳 [DeepLink] Payment ID: $paymentId, Payer ID: $payerId');

          if (paymentId != null && payerId != null) {
            await _executePayPalPayment(paymentId, payerId);
          } else {
            print(
                '❌ [DeepLink] Missing PayPal payment information - PaymentId: $paymentId, PayerId: $payerId');
            _showError('Thiếu thông tin thanh toán PayPal');
          }
        } else if (path == '/cancel') {
          print('❌ [DeepLink] PayPal payment was cancelled by user');
          // Navigate to cancelled screen
          Get.offAll(() => PaymentCancelledScreen());
        } else {
          print('⚠️ [DeepLink] Unknown PayPal path: $path');
        }
      } else if (uri.scheme == 'yourapp' && uri.host == 'vnpay') {
        final path = uri.path;
        final queryParams = uri.queryParameters;

        if (path == '/success') {
          print('✅ [DeepLink] Processing VNPay payment callback');

          // Handle VNPay payment
          final vnpTxnRef = queryParams['vnp_TxnRef'];
          final vnpResponseCode = queryParams['vnp_ResponseCode'];

          print(
              '💳 [DeepLink] VNPay TxnRef: $vnpTxnRef, Response Code: $vnpResponseCode');

          if (vnpTxnRef != null && vnpResponseCode != null) {
            // Check if payment was successful (response code '00' means success)
            if (vnpResponseCode == '00') {
              print('✅ [DeepLink] VNPay payment successful');
              await _executeVNPayPayment(vnpTxnRef, vnpResponseCode);
            } else {
              print(
                  '❌ [DeepLink] VNPay payment failed with code: $vnpResponseCode');
              _navigateToPaymentError();
            }
          } else {
            print(
                '❌ [DeepLink] Missing VNPay payment information - TxnRef: $vnpTxnRef, ResponseCode: $vnpResponseCode');
            _showError('Thiếu thông tin thanh toán VNPay');
          }
        } else if (path == '/cancel') {
          print('❌ [DeepLink] VNPay payment was cancelled by user');
          // Navigate to cancelled screen
          Get.offAll(() => PaymentCancelledScreen());
        } else {
          print('⚠️ [DeepLink] Unknown VNPay path: $path');
        }
      } else {
        print(
            '🚫 [DeepLink] Not a supported payment deep link - Scheme: ${uri.scheme}, Host: ${uri.host}');
      }
    } catch (e, stackTrace) {
      print('💥 [DeepLink] Exception in handleDeepLink: $e');
      print('📚 [DeepLink] Stack trace: $stackTrace');
      _showError('Lỗi xử lý thanh toán: $e');
    }
  }

  static Future<void> _executePayPalPayment(
      String paymentId, String payerId) async {
    try {
      print('🔄 [PayPal] Navigating to success screen with payment data');
      print('💳 [PayPal] Payment ID: $paymentId, Payer ID: $payerId');

      // Navigate to success screen with payment data for confirmation
      Get.offAll(() => PaymentSuccessScreen(), arguments: {
        'paymentId': paymentId,
        'payerId': payerId,
      });
    } catch (e, stackTrace) {
      print('💥 [PayPal] Exception in _executePayPalPayment: $e');
      print('📚 [PayPal] Stack trace: $stackTrace');
      _showError('Lỗi xử lý thanh toán: $e');
    }
  }

  static Future<void> _executeVNPayPayment(
      String vnpTxnRef, String vnpResponseCode) async {
    try {
      print('🔄 [VNPay] Navigating to success screen with payment data');
      print('💳 [VNPay] TxnRef: $vnpTxnRef, Response Code: $vnpResponseCode');

      // Navigate to success screen with payment data for confirmation
      Get.offAll(() => PaymentSuccessScreen(), arguments: {
        'vnpTxnRef': vnpTxnRef,
        'vnpResponseCode': vnpResponseCode,
      });
    } catch (e, stackTrace) {
      print('💥 [VNPay] Exception in _executeVNPayPayment: $e');
      print('📚 [VNPay] Stack trace: $stackTrace');
      _showError('Lỗi xử lý thanh toán: $e');
    }
  }

  static void _navigateToPaymentError() {
    try {
      print('🔄 [Payment] Navigating to error screen');
      Get.offAll(() => PaymentErrorScreen());
    } catch (e, stackTrace) {
      print('💥 [Payment] Exception in _navigateToPaymentError: $e');
      print('📚 [Payment] Stack trace: $stackTrace');
      _showError('Lỗi điều hướng: $e');
    }
  }

  static void _showError(String message) {
    Get.snackbar(
      'Lỗi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }
}
