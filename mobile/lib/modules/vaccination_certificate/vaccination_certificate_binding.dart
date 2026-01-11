// lib/modules/vaccination_certificate/vaccination_certificate_binding.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/modules/vaccination_certificate/vaccination_certificate_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccination_certificate_repository.dart';
import 'package:get/get.dart';

class VaccinationCertificateBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<VaccinationCertificateRepository>(
      () => VaccinationCertificateRepository(
        apiClient: Get.find<ApiServices>(),
      ),
    );

    // Controller
    Get.lazyPut<VaccinationCertificateController>(
      () => VaccinationCertificateController(
        Get.find<VaccinationCertificateRepository>(),
      ),
    );
  }
}