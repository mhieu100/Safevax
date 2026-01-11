import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_schedule_detail_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';

class VaccineScheduleDetailController extends BaseController<VaccineScheduleDetailRepository> {
  VaccineScheduleDetailController(super.repository);
  final RxMap<String, dynamic> vaccine = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Get vaccine data from arguments
    vaccine.value = Get.arguments ?? {};
  }
  
  void toVaccineScheduleScreen() {
    NavigatorHelper.toVaccineScheduleScreen();
  }
}