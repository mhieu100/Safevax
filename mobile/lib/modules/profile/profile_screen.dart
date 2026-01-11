// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/constants.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);

    return Scaffold(
      appBar: canGoBack
          ? AppBar(
              title: const Text(
                'Hồ sơ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              backgroundColor: ColorConstants.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF52D1C6),
              Color(0xFF30ADA2),
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    ImageProvider backgroundImage;
                    final avatarUrl = controller.avatarUrl.value as String;
                    if (avatarUrl.isNotEmpty) {
                      backgroundImage = NetworkImage(avatarUrl);
                    } else {
                      backgroundImage =
                          const AssetImage('assets/images/safe_vax_logo.png');
                    }
                    return CircleAvatar(
                      radius: 45,
                      backgroundImage: backgroundImage,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                        onPressed: () {
                          controller.changeAvatar();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => Text(
                    controller.username.value.isNotEmpty
                        ? controller.username.value
                        : 'Tên người dùng',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() => _StatCard(
                            iconPath: 'assets/svgs/ic_heart_beat.svg',
                            label: 'Tuổi',
                            value: controller.age.value.isNotEmpty
                                ? controller.age.value
                                : '--',
                          )),
                      const VerticalDivider(
                        color: Color(0x80FFFFFF),
                        thickness: 1,
                        width: 20,
                      ),
                      Obx(() => _StatCard(
                            iconPath: 'assets/svgs/ic_barbell.svg',
                            label: 'Chiều cao',
                            value: controller.height.value.isNotEmpty
                                ? controller.height.value
                                : '--',
                          )),
                      const VerticalDivider(
                        color: Color(0x80FFFFFF),
                        thickness: 1,
                        width: 20,
                      ),
                      Obx(() => _StatCard(
                            iconPath: 'assets/svgs/ic_fire.svg',
                            label: 'Cân nặng',
                            value: controller.weight.value.isNotEmpty
                                ? controller.weight.value
                                : '--',
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MenuItem(
                        icon: 'assets/svgs/ic_my_saved.svg',
                        title: 'Mục đã lưu',
                        onTap: () => controller.goToSavedItems(),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                      _MenuItem(
                        icon:
                            'assets/svgs/ic_payment_method.svg', // Using same icon for now
                        title: 'Tài khoản & Bảo mật',
                        onTap: () => controller.goToAccountSecurity(),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                      _MenuItem(
                        icon: 'assets/svgs/ic_faqs.svg',
                        title: 'Câu hỏi thường gặp',
                        onTap: () => controller.goToFAQs(),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      _MenuItem(
                        icon: 'assets/svgs/ic_log_out.svg',
                        title: 'Đăng xuất',
                        color: Colors.red,
                        onTap: () => controller.logout(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  _StatCard({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(iconPath, width: 32, height: 32),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: SvgPicture.asset(icon, width: 43, height: 43),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
