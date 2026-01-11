import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/bottom_nav_repository.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:get/get.dart';

class BottomNavController extends BaseController<BottomNavRepository> {
  BottomNavController(super.repository);

  
  var currentIndex = 0.obs;

  final routes = [
    Routes.dashboard,
    Routes.dashboardNoti,
    // Routes.medicalNews,
    Routes.profile,
  ];

  void onBottomNavTap(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    Get.toNamed(routes[index], id: 1); // nested navigation với key=1
  }

  void navigateToDashboard() {
    Get.toNamed(Routes.dashboard);
  }

  void replaceWithDashboard() {
    Get.offNamed(Routes.dashboard);
  }
}
