import 'dart:convert';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/modules/login/login_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class InterceptorClient extends dio.Interceptor {
  final dio.Dio _dio;

  // Mutex for synchronization
  final AsyncMemoizer<void> _refreshMemoizer = AsyncMemoizer<void>();

  // Flag to prevent multiple logout calls
  bool _isLoggingOut = false;

  static const String noRetryHeader = 'x-no-retry';

  InterceptorClient(this._dio);

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    // Skip token handling for login and register requests
    final isLoginRequest = options.uri.path.contains('/auth/login');
    final isRegisterRequest = options.uri.path.contains('/auth/register');

    if (!isLoginRequest && !isRegisterRequest) {
      final token = StorageService.token;

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Only set content-type to application/json if data is not FormData
    if (options.data is! dio.FormData) {
      options.headers['Content-Type'] = 'application/json';
    }

    log(
      """
        url(${options.method}): ${options.uri},
        headers:${jsonEncode(options.headers)},
        data: ${jsonEncode(options.data)},
      """,
      name: 'API_REQUEST',
    );

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    log(
      """
        url(${response.requestOptions.method}): ${response.requestOptions.uri},
        headers:${jsonEncode(response.requestOptions.headers)},
        data: ${jsonEncode(response.data)},
      """,
      name: 'API_RESPONSE',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(
      dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    log(
      """
        url(${err.requestOptions.method}): ${err.requestOptions.uri},
        headers:${jsonEncode(err.requestOptions.headers)},
        data: ${jsonEncode(err.response?.data)},
        error: ${err.message},
      """,
      name: 'API_ERROR',
    );

    // Skip token refresh for login and register requests
    final isLoginRequest = err.requestOptions.uri.path.contains('/auth/login');
    final isRegisterRequest =
        err.requestOptions.uri.path.contains('/auth/register');

    // Handle 401 Unauthorized (skip for login and register requests)
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.headers.containsKey(noRetryHeader) &&
        !isLoginRequest &&
        !isRegisterRequest) {
      try {
        // Use memoizer to ensure only one refresh request at a time
        await _refreshMemoizer.runOnce(() => _handleRefreshToken());

        // Check if token was refreshed
        final newToken = StorageService.token;
        if (newToken != null &&
            newToken !=
                err.requestOptions.headers['Authorization']
                    ?.replaceFirst('Bearer ', '')) {
          // Update headers with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          err.requestOptions.headers[noRetryHeader] = 'true';

          // Retry the original request
          final retryResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (refreshError) {
        log('Token refresh failed: $refreshError', name: 'API_ERROR');
        // If refresh fails, logout (only if not already logging out)
        if (!_isLoggingOut) {
          await _logout();
        }
      }
    }

    return super.onError(err, handler);
  }

  Future<void> _handleRefreshToken() async {
    try {
      // Get refresh token from storage (assuming it's stored)
      final refreshToken = StorageService.refreshToken;

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Get AuthRepository lazily
      final authRepo = Get.find<AuthRepository>();
      final response = await authRepo.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      if (response.data?.accessToken != null) {
        // Update token in storage
        StorageService.token = response.data!.accessToken;
        // Note: Refresh token handling depends on API response structure
        // If the refresh endpoint returns a new refresh token, update it here
      } else {
        throw Exception('No access token in refresh response');
      }
    } catch (e) {
      log('Refresh token error: $e', name: 'API_ERROR');
      // Only logout if not already logging out to prevent loops
      if (!_isLoggingOut) {
        await _logout();
      }
      rethrow;
    }
  }

  Future<void> _logout() async {
    // Prevent multiple logout calls
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    log('Starting logout process', name: 'LOGOUT_PROCESS');

    try {
      // Skip API logout call if no token exists (prevents unnecessary requests)
      if (StorageService.token != null) {
        log('Calling API logout endpoint', name: 'LOGOUT_PROCESS');
        try {
          final authRepo = Get.find<AuthRepository>();
          await authRepo.logout();
          log('API logout completed successfully', name: 'LOGOUT_PROCESS');
        } catch (e) {
          log('API logout failed: $e', name: 'LOGOUT_PROCESS');
        }
      } else {
        log('No token found, skipping API logout', name: 'LOGOUT_PROCESS');
      }

      // Clear loading state before navigation
      try {
        final loginController = Get.find<LoginController>();
        loginController.isLoading(false);
        log('Cleared login loading state', name: 'LOGOUT_PROCESS');
      } catch (e) {
        // LoginController might not be available, ignore
        log('LoginController not available for loading state reset',
            name: 'LOGOUT_PROCESS');
      }

      log('Clearing storage', name: 'LOGOUT_PROCESS');
      StorageService.clear();

      log('Navigating to login screen', name: 'LOGOUT_PROCESS');
      NavigatorHelper.toLoginScreen();

      log('Logout process completed', name: 'LOGOUT_PROCESS');
    } finally {
      _isLoggingOut = false;
    }
  }
}
