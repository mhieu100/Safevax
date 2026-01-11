import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/account_security_repository.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:get/get.dart';

class AccountSecurityController
    extends BaseController<AccountSecurityRepository> {
  AccountSecurityController(super.repository);

  var userName = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var avatarUrl = "".obs;
  var is2FAEnabled = false.obs;
  var isBiometricEnabled = false.obs;
  var isDataSharingEnabled = false.obs;
  var isLocationEnabled = false.obs;
  var isNotificationEnabled = true.obs;

  @override
  Future getData() async {
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setLoading(true);
      final userData = StorageService.userData;
      if (userData != null) {
        final user = User.fromJson(userData);
        userName.value = user.fullName ?? '';
        phoneNumber.value = user.phone ?? '';
        email.value = user.email ?? '';
        // avatarUrl and other settings can be loaded if available
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      setLoading(false);
    }
  }
}
