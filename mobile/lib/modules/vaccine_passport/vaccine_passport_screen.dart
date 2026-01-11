// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'vaccine_passport_controller.dart';

class VaccinePassportScreen
    extends GetView<VaccinePassportController> {
  const VaccinePassportScreen({super.key});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF199A8E),
        title: const Text(
          "Vaccine Passport",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // QR Code
            Obx(() => QrImageView(
                  data: controller.qrData.value,
                  size: 220,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    color: Color(0xFF199A8E),
                    eyeShape: QrEyeShape.square,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: Color(0xFF199A8E),
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                )),

            const SizedBox(height: 20),

            // Verification status
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.isVerified.value
                          ? Icons.verified
                          : Icons.error_outline,
                      color: controller.isVerified.value
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.isVerified.value
                          ? "Verified on Blockchain"
                          : "Verification Failed",
                      style: TextStyle(
                        color: controller.isVerified.value
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 30),

            // Details section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF199A8E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🔐 Blockchain Protection",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF199A8E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This vaccination record is digitally signed by the Ministry of Health "
                    "and stored securely on the blockchain. It cannot be altered or forged.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Refresh QR button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF199A8E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Refresh QR Code",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Example refresh logic
                controller.qrData.value =
                    "safevax://vaccine-passport/${DateTime.now().millisecondsSinceEpoch}";
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}