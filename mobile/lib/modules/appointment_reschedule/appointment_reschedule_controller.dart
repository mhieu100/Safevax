import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:get/get.dart';

class AppointmentRescheduleController
    extends BaseController<AppointmentRescheduleRepository> {
  AppointmentRescheduleController(super.repository);

  var selectedDate = DateTime.now().obs;
  var selectedTime = "".obs;

  List<String> timeSlots = [
    "07:00 - 09:00",
    "09:00 - 11:00",
    "11:00 - 13:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
  ];

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(String time) {
    selectedTime.value = time;
  }
}
