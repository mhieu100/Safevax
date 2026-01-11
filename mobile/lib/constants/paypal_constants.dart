import 'package:flutter_dotenv/flutter_dotenv.dart';

class PayPalConfig {
  // PayPal API Configuration
  static String get clientId {
    final value =
        dotenv.isInitialized ? (dotenv.env['PAYPAL_CLIENT_ID'] ?? '') : '';
    print(
        '🔑 [PayPalConfig] clientId: ${value.isNotEmpty ? "***${value.substring(value.length - 4)}" : "empty"}');
    return value;
  }

  static String get clientSecret {
    final value =
        dotenv.isInitialized ? (dotenv.env['PAYPAL_CLIENT_SECRET'] ?? '') : '';
    print(
        '🔑 [PayPalConfig] clientSecret: ${value.isNotEmpty ? "***${value.substring(value.length - 4)}" : "empty"}');
    return value;
  }

  static String get environment {
    final value = dotenv.isInitialized
        ? (dotenv.env['PAYPAL_ENVIRONMENT'] ?? 'sandbox')
        : 'sandbox';
    print('🌐 [PayPalConfig] environment: $value');
    return value;
  }

  // PayPal URLs
  static String get baseUrl => environment == 'production'
      ? 'https://api.paypal.com'
      : 'https://api.sandbox.paypal.com';

  static String get checkoutUrl => environment == 'production'
      ? 'https://www.paypal.com'
      : 'https://www.sandbox.paypal.com';

  // App return URLs
  static String get returnUrl => dotenv.isInitialized
      ? (dotenv.env['PAYPAL_RETURN_URL'] ?? 'yourapp://paypal/success')
      : 'yourapp://paypal/success';
  static String get cancelUrl => dotenv.isInitialized
      ? (dotenv.env['PAYPAL_CANCEL_URL'] ?? 'yourapp://paypal/cancel')
      : 'yourapp://paypal/cancel';

  // Currency and other settings
  static const String currency = 'USD'; // PayPal typically uses USD
  static const String intent = 'CAPTURE'; // or 'AUTHORIZE'
}
