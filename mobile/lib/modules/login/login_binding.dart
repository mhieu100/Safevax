import 'package:flutter_getx_boilerplate/modules/login/login_controller.dart';
import 'package:flutter_getx_boilerplate/models/request/refresh_token_request.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/login_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Ensure AuthRepository is available for interceptor
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put(AuthRepository(apiClient: Get.find()), permanent: true);
    }

    Get.lazyPut<LoginRepository>(
      () => LoginRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find()),
    );

    // Check for auto-login after dependencies are set up
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    // Wait for next frame to ensure everything is initialized
    await Future.delayed(Duration.zero);

    // Check if token exists and try to validate it
    if (StorageService.token != null && StorageService.refreshToken != null) {
      try {
        final authRepo = Get.find<AuthRepository>();
        await authRepo.refreshToken(
          RefreshTokenRequest(refreshToken: StorageService.refreshToken!),
        ); // This will validate and refresh the token
        // If successful, navigate to bottom nav
        NavigatorHelper.toBottomNavigationScreen();
      } catch (e) {
        // Token is invalid, stay on login screen
        // Storage will be cleared by interceptor if needed
      }
    }
  }
}
