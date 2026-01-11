import 'dart:developer';

import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_management_repository.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    log('Initializing app dependencies', name: 'APP_BINDING');
    Get.put(ApiServices(), permanent: true);
    Get.lazyPut(() => VaccineManagementRepository(apiClient: Get.find()),
        fenix: true);
    // AuthRepository will be registered lazily when needed
    log('App dependencies initialized', name: 'APP_BINDING');
  }
}
