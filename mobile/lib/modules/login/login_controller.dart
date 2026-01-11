import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_boilerplate/repositories/login_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/models/request/login_request.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/shared/enum/flavors_enum.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends BaseController<LoginRepository> {
  LoginController(super.repository);

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var passwordVisible = false.obs;
  var isEmailValid = true.obs;
  var isPasswordWrong = false.obs;
  var isLoading = false.obs;

  // Cancel token for request cancellation
  CancelToken? _cancelToken;

  Color get emailBorderColor => isEmailValid.value ? Colors.grey : Colors.red;
  Color get passwordBorderColor =>
      isPasswordWrong.value ? Colors.red : Colors.grey;

  @override
  onInit() {
    super.onInit();
    emailController.text = 'thuphuong@gmail.com';
    passwordController.text = 'phuong123456';
  }

  // Email validation function
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Login function
  Future<void> onLogin() async {
    // Cancel any ongoing request
    _cancelToken?.cancel('New login attempt');
    _cancelToken = CancelToken();

    isLoading(true);
    try {
      // Validate email
      isEmailValid.value = validateEmail(emailController.text);
      if (!isEmailValid.value) {
        isLoading(false);
        Get.snackbar(
          'Lỗi',
          'Vui lòng nhập email hợp lệ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Validate password
      if (passwordController.text.isEmpty) {
        isLoading(false);
        isPasswordWrong.value = true;
        Get.snackbar(
          'Lỗi',
          'Vui lòng nhập mật khẩu',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Call login API
      final request = LoginRequest(
        username: emailController.text,
        password: passwordController.text,
      );

      final response =
          await repository.login(request, cancelToken: _cancelToken);

      // Check if login successful
      if (response.statusCode == 200 && response.data?.accessToken != null) {
        // Save token
        StorageService.token = response.data!.accessToken!;

        // Save user data
        if (response.data?.user != null) {
          StorageService.userData = response.data!.user!.toJson();
        }

        isLoading(false); // Ensure loading stops

        // Check profile completeness
        _checkProfileAndNavigate(response.data!.user!);
      } else {
        isLoading(false);
        // Set password error state for UI feedback
        isPasswordWrong.value = true;
        // Don't show snackbar, just update error text in UI
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        // Request was cancelled, don't show error
        return;
      }
      isLoading(false);
      // Set password error state for UI feedback
      isPasswordWrong.value = true;
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      isLoading(false);
      // Set password error state for UI feedback
      isPasswordWrong.value = true;
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> onGoogleLogin() async {
    isLoading(true);
    try {
      // Log current app flavor and API configuration
      debugPrint('Google Sign-In: Current app flavor: ${F.appFlavor}');
      debugPrint('Google Sign-In: API base URL: ${F.toBaseurl()}');
      debugPrint(
          'Google Sign-In: Full Google login endpoint: ${F.toBaseurl()}auth/login/google');

      // Check network connectivity by testing backend reachability
      debugPrint('Google Sign-In: Testing backend connectivity...');
      try {
        final connectivityResponse = await Dio().get('${F.toBaseurl()}health',
            options: Options(
                sendTimeout: Duration(seconds: 5),
                receiveTimeout: Duration(seconds: 5),
                validateStatus: (status) =>
                    status != null && (status < 500 || status == 401)));
        debugPrint(
            'Google Sign-In: Backend connectivity test - Status: ${connectivityResponse.statusCode}');
        if (connectivityResponse.statusCode == 401) {
          debugPrint(
              'Google Sign-In: Backend is reachable but requires authentication (expected for protected endpoint)');
        }
      } catch (connectivityError) {
        debugPrint(
            'Google Sign-In: Backend connectivity test failed - $connectivityError');
        debugPrint(
            'Google Sign-In: This may indicate network issues or backend server down');
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId:
              '1070908730094-0norm87v51igtms030htqb34np4cspah.apps.googleusercontent.com',
          scopes: ['email', 'profile', 'openid']);
      debugPrint(
          'Google Sign-In: Initializing GoogleSignIn with scopes: ${googleSignIn.scopes}');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      debugPrint('Google Sign-In: googleUser = $googleUser');
      if (googleUser != null) {
        debugPrint('Google Sign-In: googleUser.email = ${googleUser.email}');
        debugPrint(
            'Google Sign-In: googleUser.displayName = ${googleUser.displayName}');
        debugPrint('Google Sign-In: googleUser.id = ${googleUser.id}');
      }

      if (googleUser == null) {
        // User cancelled the sign-in
        debugPrint('Google Sign-In: User cancelled sign-in');
        isLoading(false);
        return;
      }

      debugPrint('Google Sign-In: Attempting to get authentication...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      debugPrint('Google Sign-In: googleAuth = $googleAuth');
      debugPrint('Google Sign-In: idToken = $idToken');
      debugPrint('Google Sign-In: accessToken = $accessToken');
      debugPrint('Google Sign-In: idToken length = ${idToken?.length}');
      debugPrint('Google Sign-In: accessToken length = ${accessToken?.length}');

      // Validate idToken format (should be JWT with 3 parts separated by dots)
      if (idToken != null) {
        final tokenParts = idToken.split('.');
        debugPrint(
            'Google Sign-In: idToken parts count = ${tokenParts.length}');
        if (tokenParts.length != 3) {
          debugPrint(
              'Google Sign-In: WARNING - idToken does not have 3 parts (header.payload.signature)');
        } else {
          debugPrint('Google Sign-In: idToken format appears valid');
        }

        // Additional token validation - check if token can be decoded
        try {
          // Basic JWT header validation
          final header = tokenParts[0];
          debugPrint('Google Sign-In: idToken header length: ${header.length}');
          // We could decode base64url here if needed for more validation
        } catch (e) {
          debugPrint('Google Sign-In: Error validating idToken format: $e');
        }
      }

      if (idToken == null) {
        debugPrint(
            'Google Sign-In: idToken is null - Google authentication failed');
        isLoading(false);
        Get.snackbar(
          'Lỗi',
          'Không thể lấy idToken từ Google',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Call Google login API
      debugPrint('Google Sign-In: Calling API with idToken');
      final response = await repository.googleLogin(idToken);

      debugPrint('Google Sign-In: API response = $response');
      debugPrint(
          'Google Sign-In: response.statusCode = ${response.statusCode}');
      debugPrint('Google Sign-In: response.data = ${response.data}');

      // Check if login successful
      if (response.statusCode == 200 && response.data?.accessToken != null) {
        debugPrint('Google Sign-In: Login successful');
        // Save token
        StorageService.token = response.data!.accessToken!;

        // Save user data
        if (response.data?.user != null) {
          StorageService.userData = response.data!.user!.toJson();
          debugPrint(
              'Google Sign-In: User data saved = ${response.data!.user}');
        }

        isLoading(false);

        // Check profile completeness
        _checkProfileAndNavigate(response.data!.user!);
      } else {
        debugPrint(
            'Google Sign-In: Login failed - statusCode: ${response.statusCode}, data: ${response.data}');
        isLoading(false);
        Get.snackbar(
          'Lỗi',
          'Đăng nhập Google thất bại',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In: Exception occurred - $e');
      debugPrint('Google Sign-In: Exception type: ${e.runtimeType}');
      debugPrint(
          'Google Sign-In: Exception stack trace: ${StackTrace.current}');

      if (e is PlatformException) {
        debugPrint('Google Sign-In: PlatformException code: ${e.code}');
        debugPrint('Google Sign-In: PlatformException message: ${e.message}');
        debugPrint('Google Sign-In: PlatformException details: ${e.details}');
      } else if (e is DioException) {
        debugPrint('Google Sign-In: DioException type: ${e.type}');
        debugPrint('Google Sign-In: DioException message: ${e.message}');
        debugPrint(
            'Google Sign-In: DioException response status: ${e.response?.statusCode}');
        debugPrint(
            'Google Sign-In: DioException response data: ${e.response?.data}');
        debugPrint(
            'Google Sign-In: DioException request URL: ${e.requestOptions.uri}');
        debugPrint(
            'Google Sign-In: DioException request data: ${e.requestOptions.data}');
      }

      isLoading(false);
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi đăng nhập Google. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void toRegister() {
    NavigatorHelper.toMedicalProfileScreen();
  }

  void toForgotPasswordScreen() {
    NavigatorHelper.toForgotPasswordScreen();
  }

  void _checkProfileAndNavigate(User user) {
    if (user.isActive == false) {
      // User chưa active -> Chuyển sang complete profile
      NavigatorHelper.toCompleteProfileScreen();
    } else {
      // User đã active -> Vào trang chủ
      NavigatorHelper.toBottomNavigationScreen();
    }
  }

  @override
  void onClose() {
    _cancelToken?.cancel('Controller disposed');
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
