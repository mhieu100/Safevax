// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/account_security/account_security_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class AccountSecurityScreen extends GetView<AccountSecurityController> {
  const AccountSecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          "Tài khoản & Bảo mật",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Settings Sections
            _buildAuthenticationSection(),
            _buildProfileSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticationSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: Icon(Icons.lock, color: ColorConstants.primaryGreen),
        title: const Text('Đổi mật khẩu'),
        subtitle: const Text('Cập nhật mật khẩu tài khoản của bạn'),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: ColorConstants.primaryGreen),
        onTap: () {
          Get.toNamed(Routes.changePassword);
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: Icon(Icons.person, color: ColorConstants.primaryGreen),
        title: const Text('Cập nhật hồ sơ bệnh nhân'),
        subtitle: const Text('Chỉnh sửa thông tin hồ sơ y tế của bạn'),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: ColorConstants.primaryGreen),
        onTap: () {
          Get.toNamed(Routes.editProfile);
        },
      ),
    );
  }
}
