import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Thanh toán thất bại!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Có lỗi xảy ra trong quá trình thanh toán.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to booking or home
                Get.offAllNamed('/bottomNav');
              },
              child: Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
