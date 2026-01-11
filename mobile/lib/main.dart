import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/di.dart';
// import 'package:flutter_getx_boilerplate/shared/enum/flavors_enum.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/services/paypal_deep_link_handler.dart';
import 'package:app_links/app_links.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);

  // Load environment variables
  print('🔧 [Main] Loading environment variables...');
  await dotenv.load(fileName: '.env.dev'); // or '.env.prod' based on flavor
  print(
      '✅ [Main] Environment variables loaded. IsInitialized: ${dotenv.isInitialized}');
  print('🔑 [Main] VNPAY_TMN_CODE: ${dotenv.env['VNPAY_TMN_CODE']}');

  await DependencyInjection.init();

  // Initialize deep link handling
  _initDeepLinkHandling();

  runApp(const App());

  configLoading();
}

void _initDeepLinkHandling() {
  final appLinks = AppLinks();

  // Handle deep links when app is launched from terminated state
  appLinks.getInitialLink().then((Uri? uri) {
    if (uri != null) {
      PayPalDeepLinkHandler.handleDeepLink(uri);
    }
  });

  // Handle deep links when app is already running
  appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      PayPalDeepLinkHandler.handleDeepLink(uri);
    }
  });
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    ..radius = 10.0
    // ..progressColor = Colors.yellow
    ..backgroundColor = ColorConstants.lightGray
    ..indicatorColor = hexToColor('#64DEE0')
    ..textColor = hexToColor('#64DEE0')
    // ..maskColor = Colors.red
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
