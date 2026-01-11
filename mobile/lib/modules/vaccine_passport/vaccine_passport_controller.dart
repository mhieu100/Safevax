import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_passport_repository.dart';
import 'package:get/get.dart';

class VaccinePassportController
    extends BaseController<VaccinePassportRepository> {
  VaccinePassportController(super.repository);


  final qrData = "safevax://vaccine-passport/123456789".obs;
  final isVerified = true.obs; // Blockchain verification status
}