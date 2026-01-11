import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_payment_repository.dart';
import 'package:get/get.dart';

class VaccinePaymentController extends BaseController<VaccinePaymentRepository> {
  VaccinePaymentController(super.repository);

  var isLoading = false.obs;

  // Fake vaccine data
  var vaccineName = "Pfizer-BioNTech COVID-19".obs;
  var vaccineDose = "Mũi 2".obs;
  var vaccinePrice = 450000.obs; // VND

  void connectEWallet() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    await repository.connectEWallet();
    isLoading.value = false;
  }

  void bankTransfer() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    await repository.bankTransfer();
    isLoading.value = false;
  }

  void makePayment() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    await repository.makePayment();
    isLoading.value = false;
  }
}
