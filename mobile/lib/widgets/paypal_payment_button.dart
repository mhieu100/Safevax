import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';

class PayPalPaymentButton extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final int itemCount;

  const PayPalPaymentButton({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.itemCount,
  }) : super(key: key);

  @override
  _PayPalPaymentButtonState createState() => _PayPalPaymentButtonState();
}

class _PayPalPaymentButtonState extends State<PayPalPaymentButton> {
  bool _isLoading = false;

  void _startPayPalPayment() async {
    setState(() => _isLoading = true);

    try {
      // 1. Tạo order trước
      final orderResponse = await PaymentService.createPayPalOrder(
        items: widget.cartItems,
        totalAmount: widget.totalAmount,
      );

      if (orderResponse['id'] != null) {
        // 2. Extract approval URL and open PayPal checkout
        final approvalUrl = _getApprovalUrl(orderResponse);
        if (approvalUrl != null) {
          _openPayPalCheckout(approvalUrl);
        } else {
          _showError('Không thể lấy URL thanh toán PayPal');
        }
      } else {
        _showError('Không thể tạo đơn hàng PayPal');
      }
    } catch (e) {
      _showError('Lỗi kết nối: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _getApprovalUrl(Map<String, dynamic> orderResponse) {
    final links = orderResponse['links'] as List?;
    if (links != null) {
      for (var link in links) {
        if (link['rel'] == 'approval_url') {
          return link['href'];
        }
      }
    }
    return null;
  }

  void _openPayPalCheckout(String approvalUrl) async {
    try {
      final uri = Uri.parse(approvalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Không thể mở PayPal checkout');
      }
    } catch (e) {
      _showError('Lỗi mở PayPal: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _startPayPalPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0070BA), // PayPal blue
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.paypal, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Thanh toán với PayPal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
