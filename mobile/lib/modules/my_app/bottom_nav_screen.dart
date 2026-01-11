// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Obx(() => Scaffold(
          body: Navigator(
            key: Get.nestedKey(1),
            onGenerateRoute: (settings) {
              return GetPageRoute(
                page: () => GetRouterOutlet(
                  initialRoute: controller.routes[controller.currentIndex.value],
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: controller.currentIndex.value,
                selectedItemColor: ColorConstants.secondaryGreen,
                unselectedItemColor: ColorConstants.darkGray,
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                onTap: controller.onBottomNavTap,
                items: [
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == 0
                            ? ColorConstants.secondaryGreen.withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.currentIndex.value == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        size: 24,
                      ),
                    ),
                    label: 'Trang chủ',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == 1
                            ? ColorConstants.secondaryGreen.withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Icon(
                            controller.currentIndex.value == 1
                                ? Icons.notifications_rounded
                                : Icons.notifications_outlined,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: 'Thông báo',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == 2
                            ? ColorConstants.secondaryGreen.withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.currentIndex.value == 2
                            ? Icons.person_rounded
                            : Icons.person_outlined,
                        size: 24,
                      ),
                    ),
                    label: 'Hồ sơ',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
