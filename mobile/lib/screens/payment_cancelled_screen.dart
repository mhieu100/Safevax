import 'package:flutter/material.dart';

class PaymentCancelledScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.orange, size: 100),
            SizedBox(height: 20),
            Text(
              'Thanh toán đã bị hủy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Bạn có thể thử lại hoặc chọn phương thức thanh toán khác',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to cart/payment screen
                Navigator.of(context).pop();
              },
              child: Text('Thử lại'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to home
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
