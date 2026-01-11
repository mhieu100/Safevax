import 'package:flutter_getx_boilerplate/modules/vaccine_list/booking_summary/booking_summary_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/booking_summary_repository.dart';
import 'package:get/get.dart';

class BookingSummaryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSummaryRepository>(
      () => BookingSummaryRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<BookingSummaryController>(
      () => BookingSummaryController(Get.find()),
    );
  }
}
