import 'package:flutter_dotenv/flutter_dotenv.dart';

class VNPayConfig {
  static String get tmnCode =>
      dotenv.isInitialized ? (dotenv.env['VNPAY_TMN_CODE'] ?? '') : '';
  static String get hashSecret =>
      dotenv.isInitialized ? (dotenv.env['VNPAY_HASH_SECRET'] ?? '') : '';
  static String get url => dotenv.isInitialized
      ? (dotenv.env['VNPAY_URL'] ??
          'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html')
      : 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  static String get returnUrl => dotenv.isInitialized
      ? (dotenv.env['VNPAY_RETURN_URL'] ??
          '${dotenv.env['BASE_URL']}/payment/vnpay-return')
      : 'https://yourdomain.com/payment/vnpay-return';

  static const String version = '2.1.0';
  static const String command = 'pay';
  static const String currencyCode = 'VND';
  static const String locale = 'vn';
  static const String orderType = 'other';
}
