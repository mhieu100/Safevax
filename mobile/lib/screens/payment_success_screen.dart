import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/payment_service.dart';

class PaymentSuccessScreen extends StatefulWidget {
  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isConfirming = true;
  String? _error;
  Map<String, dynamic>? _paymentData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confirmPayment();
    });
  }

  Future<void> _confirmPayment() async {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      // Check for PayPal payment
      final paymentId = args['paymentId'] as String?;
      final payerId = args['payerId'] as String?;

      if (paymentId != null && payerId != null) {
        // For PayPal, payment is already confirmed by the gateway
        // Just show success
        print(
            '✅ [PaymentSuccess] PayPal payment successful - no backend confirmation needed');
        setState(() {
          _isConfirming = false;
          _paymentData = {'orderId': paymentId}; // Use paymentId as orderId
        });
        return;
      } else {
        // Check for VNPay payment
        final vnpTxnRef = args['vnpTxnRef'] as String?;
        final vnpResponseCode = args['vnpResponseCode'] as String?;

        if (vnpTxnRef != null && vnpResponseCode != null) {
          // For VNPay, payment is already confirmed by the gateway
          // Just show success
          print(
              '✅ [PaymentSuccess] VNPay payment successful - no backend confirmation needed');
          setState(() {
            _isConfirming = false;
            _paymentData = {'orderId': vnpTxnRef}; // Use txnRef as orderId
          });
          return;
        } else {
          _error = 'Thiếu thông tin thanh toán';
        }
      }
    } else {
      _error = 'Không có thông tin thanh toán';
    }

    setState(() => _isConfirming = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isConfirming
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Đang xác nhận thanh toán...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : _error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 64),
                      SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Thử lại'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 100),
                      SizedBox(height: 20),
                      Text(
                        'Thanh toán thành công!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      if (_paymentData != null)
                        Text(
                          'Mã đơn hàng: ${_paymentData!['orderId'] ?? 'N/A'}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to home
                          Get.offAllNamed(Routes.bottomNav);
                        },
                        child: Text('Về trang chủ'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
