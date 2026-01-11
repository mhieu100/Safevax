import 'package:flutter_getx_boilerplate/modules/vaccine_list/booking_vaccines/booking_vaccines_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/booking_vaccines_repository.dart';
import 'package:get/get.dart';

class BookingVaccinesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingVaccinesRepository>(
      () => BookingVaccinesRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<BookingVaccinesController>(
      () => BookingVaccinesController(Get.find()),
    );
  }
}
