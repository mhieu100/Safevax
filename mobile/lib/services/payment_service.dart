import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/shared/enum/flavors_enum.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_getx_boilerplate/constants/vnpay_constants.dart';
import 'package:flutter_getx_boilerplate/constants/paypal_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Backend URL - thay localhost bằng production URL
  static String get backendBaseUrl {
    final url = F.toBaseurl() ?? 'https://backend.mhieu100.space/api/';
    // Remove trailing slash to avoid double slashes
    return url.replaceAll(RegExp(r'/$'), '');
  }

  // PayPal deep link URLs
  static const String paypalReturnUrl = 'yourapp://paypal/success';
  static const String paypalCancelUrl = 'yourapp://paypal/cancel';

  // VNPay deep link URLs
  static const String vnpayReturnUrl = 'yourapp://vnpay/success';
  static const String vnpayCancelUrl = 'yourapp://vnpay/cancel';

  // Currency
  static const String currency = 'USD'; // hoặc 'VND' tùy backend
}

class PaymentService {
  // Get JWT token from storage
  static Future<String> getToken() async {
    print('🔑 [PaymentService] Retrieving JWT token from storage');
    final token = StorageService.token;

    if (token == null || token.isEmpty) {
      print('❌ [PaymentService] No authentication token found in storage');
      throw Exception('No authentication token found');
    }

    print(
        '✅ [PaymentService] Token retrieved successfully (length: ${token.length})');
    return token;
  }

  // Tạo order với PayPal payment (frontend implementation)
  static Future<Map<String, dynamic>> createPayPalOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    print('🔐 [PaymentService] Creating PayPal order on frontend');
    print(
        '🔧 [PaymentService] PayPal client ID available: ${PayPalConfig.clientId.isNotEmpty}');
    print(
        '🔧 [PaymentService] PayPal environment: ${PayPalConfig.environment}');

    try {
      // Get PayPal access token
      final accessToken = await _getPayPalAccessToken();
      print('✅ [PaymentService] PayPal access token obtained');

      // Create PayPal order
      final orderResponse =
          await _createPayPalOrderRequest(accessToken, items, totalAmount);
      print('📨 [PaymentService] PayPal order response: $orderResponse');

      if (orderResponse['status'] == 'CREATED' &&
          orderResponse['links'] != null) {
        // Find approval URL
        final approvalLink = orderResponse['links'].firstWhere(
          (link) => link['rel'] == 'approve',
          orElse: () => null,
        );

        if (approvalLink != null) {
          print('✅ [PaymentService] PayPal order created successfully');
          print('🔗 [PaymentService] Approval URL: ${approvalLink['href']}');

          return {
            'statusCode': 200,
            'data': {
              'paymentURL': approvalLink['href'],
              'orderId': orderResponse['id'],
            },
            'message': 'PayPal order created successfully'
          };
        } else {
          print('❌ [PaymentService] No approval link found in PayPal response');
          throw Exception('No approval link found in PayPal response');
        }
      } else {
        print(
            '❌ [PaymentService] PayPal order creation failed: ${orderResponse['status']}');
        throw Exception(
            'PayPal order creation failed: ${orderResponse['status']}');
      }
    } catch (e) {
      print('❌ [PaymentService] Error creating PayPal order: $e');
      throw Exception('Failed to create PayPal order: $e');
    }
  }

  // Get PayPal access token
  static Future<String> _getPayPalAccessToken() async {
    final credentials = base64Encode(
        utf8.encode('${PayPalConfig.clientId}:${PayPalConfig.clientSecret}'));

    final response = await http.post(
      Uri.parse('${PayPalConfig.baseUrl}/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception(
          'Failed to get PayPal access token: ${response.statusCode}');
    }
  }

  // Create PayPal order request
  static Future<Map<String, dynamic>> _createPayPalOrderRequest(
    String accessToken,
    List<Map<String, dynamic>> items,
    double totalAmount,
  ) async {
    final orderData = {
      'intent': PayPalConfig.intent,
      'purchase_units': [
        {
          'amount': {
            'currency_code': PayPalConfig.currency,
            'value': totalAmount.toStringAsFixed(2),
          },
          'description': 'Vaccine booking payment',
        }
      ],
      'application_context': {
        'return_url': PayPalConfig.returnUrl,
        'cancel_url': PayPalConfig.cancelUrl,
      },
    };

    final response = await http.post(
      Uri.parse('${PayPalConfig.baseUrl}/v2/checkout/orders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to create PayPal order: ${response.statusCode} - ${response.body}');
    }
  }

  // Xác nhận PayPal payment (gọi backend API)
  static Future<Map<String, dynamic>> confirmPayPalPayment({
    required String paymentId,
    required String payerId,
  }) async {
    print('🔐 [PaymentService] Getting authentication token for confirmation');
    final token = await getToken();
    print('✅ [PaymentService] Token retrieved successfully');

    final requestBody = {
      'paymentId': paymentId,
      'payerId': payerId,
    };

    print(
        '📡 [PaymentService] Calling POST ${AppConfig.backendBaseUrl}/payments/paypal/confirm');
    print('📦 [PaymentService] Request body: $requestBody');

    final response = await http.post(
      Uri.parse('${AppConfig.backendBaseUrl}/payments/paypal/confirm'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print(
        '📨 [PaymentService] Confirmation response status: ${response.statusCode}');
    print('📨 [PaymentService] Confirmation response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('🔍 [PaymentService] Parsed confirmation response: $data');

      // Check if backend response indicates success for confirmation
      if (data['statusCode'] == 200) {
        print('✅ [PaymentService] PayPal payment confirmed successfully');
        return data;
      } else {
        print(
            '❌ [PaymentService] Backend confirmation error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to confirm PayPal payment');
      }
    } else {
      print(
          '❌ [PaymentService] HTTP confirmation error ${response.statusCode}: ${response.body}');
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Helper method to prepare cart items for API
  static List<Map<String, dynamic>> prepareCartItems(
      List<Map<String, dynamic>> rawItems) {
    return rawItems
        .map((item) => {
              'id': item['id'],
              'quantity': item['quantity'] ?? 1,
            })
        .toList();
  }

  // Tạo order với VNPay payment (manual implementation)
  static Future<Map<String, dynamic>> createVNPayOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    print('🔐 [PaymentService] Creating VNPay order manually');
    print('🔧 [PaymentService] Dotenv isInitialized: ${dotenv.isInitialized}');
    print(
        '🔑 [PaymentService] VNPAY_TMN_CODE available: ${dotenv.env['VNPAY_TMN_CODE'] != null}');

    try {
      // Generate unique transaction reference
      final txnRef = 'VNPAY${DateTime.now().millisecondsSinceEpoch}';

      // Calculate amount in VND (VNPay requires amount in smallest currency unit)
      final amount =
          (totalAmount * 100).toInt(); // Convert to VND smallest unit

      // Create VNPay payment parameters
      final createDate = DateTime.now();
      final createDateStr =
          '${createDate.year}${createDate.month.toString().padLeft(2, '0')}${createDate.day.toString().padLeft(2, '0')}${createDate.hour.toString().padLeft(2, '0')}${createDate.minute.toString().padLeft(2, '0')}${createDate.second.toString().padLeft(2, '0')}';

      final params = {
        'vnp_Version': VNPayConfig.version,
        'vnp_Command': VNPayConfig.command,
        'vnp_TmnCode': VNPayConfig.tmnCode,
        'vnp_Amount': amount.toString(),
        'vnp_CurrCode': VNPayConfig.currencyCode,
        'vnp_TxnRef': txnRef,
        'vnp_OrderInfo': 'Thanh toan don hang vaccine',
        'vnp_OrderType': VNPayConfig.orderType,
        'vnp_Locale': VNPayConfig.locale,
        'vnp_ReturnUrl': VNPayConfig.returnUrl,
        'vnp_IpAddr': '127.0.0.1', // You might want to get actual IP
        'vnp_CreateDate': createDateStr,
      };

      // Sort parameters and create signature string
      final sortedKeys = params.keys.toList()..sort();
      final signData = sortedKeys.map((key) => '$key=${params[key]}').join('&');

      // Generate HMAC-SHA512 signature
      final key = utf8.encode(VNPayConfig.hashSecret);
      final bytes = utf8.encode(signData);
      final hmacSha512 = Hmac(sha512, key);
      final digest = hmacSha512.convert(bytes);
      final signature = digest.toString();

      // Add signature to parameters
      params['vnp_SecureHash'] = signature;

      // Build payment URL
      final queryString = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      final paymentUrl = '${VNPayConfig.url}?$queryString';

      print('✅ [PaymentService] VNPay payment URL generated successfully');
      print('🔗 [PaymentService] Payment URL: $paymentUrl');
      print('💳 [PaymentService] Transaction Ref: $txnRef');

      return {
        'statusCode': 200,
        'data': {
          'paymentURL': paymentUrl,
          'txnRef': txnRef,
        },
        'message': 'VNPay order created successfully'
      };
    } catch (e) {
      print('❌ [PaymentService] Error generating VNPay URL: $e');
      throw Exception('Failed to create VNPay order: $e');
    }
  }

  // Xác nhận VNPay payment (gọi backend API)
  static Future<Map<String, dynamic>> confirmVNPayPayment({
    required String vnpTxnRef,
    required String vnpResponseCode,
  }) async {
    print('🔐 [PaymentService] Getting authentication token for confirmation');
    final token = await getToken();
    print('✅ [PaymentService] Token retrieved successfully');

    final requestBody = {
      'vnpTxnRef': vnpTxnRef,
      'vnpResponseCode': vnpResponseCode,
    };

    print(
        '📡 [PaymentService] Calling POST ${AppConfig.backendBaseUrl}/payments/vnpay/confirm');
    print('📦 [PaymentService] Request body: $requestBody');

    final response = await http.post(
      Uri.parse('${AppConfig.backendBaseUrl}/payments/vnpay/confirm'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print(
        '📨 [PaymentService] Confirmation response status: ${response.statusCode}');
    print('📨 [PaymentService] Confirmation response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('🔍 [PaymentService] Parsed confirmation response: $data');

      // Check if backend response indicates success for confirmation
      if (data['statusCode'] == 200) {
        print('✅ [PaymentService] VNPay payment confirmed successfully');
        return data;
      } else {
        print(
            '❌ [PaymentService] Backend confirmation error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to confirm VNPay payment');
      }
    } else {
      print(
          '❌ [PaymentService] HTTP confirmation error ${response.statusCode}: ${response.body}');
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Handle authentication errors (401)
  static Future<void> handleAuthError() async {
    print(
        '🔐 [PaymentService] Handling authentication error - token may be expired');

    // Clear invalid token and user data
    StorageService.clear();
    print(
        '🗑️ [PaymentService] Cleared invalid token and user data from storage');

    // Navigate to login screen
    Get.offAllNamed('/login'); // Adjust route name as needed
    print('🔄 [PaymentService] Redirected to login screen');

    // Show message to user
    Get.snackbar(
      'Phiên đăng nhập hết hạn',
      'Vui lòng đăng nhập lại để tiếp tục',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }
}
