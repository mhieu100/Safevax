import 'package:flutter/material.dart';

class ColorConstants {
  // Primary color
  static const Color primaryGreen = Color(0xFF00766a);
  // static final Color secondaryGreen = const Color(0xFF199A8E).withValues(alpha: 0.9);
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color lightGreen = Color(0xFF059669);
  static const Color buttontGreen =  Color(0xFF10B981);


  // 
  static const Color lightBackGround = Color(0xFFF8FAFC);



  // Scaffold Background Colors
  static const Color lightScaffoldBackgroundColor = Color(0xFFF9F9F9);
  static const Color darkScaffoldBackgroundColor = Color(0xFF2F2E2E);

  // Secondary Colors
  static const Color secondaryAppColor = Color(0xFF22DDA6);
  static const Color secondaryDarkAppColor = Colors.white;

  // Neutral Colors
  static const Color tipColor = Color(0xFFB6B6B6);
  static const Color lightGray = Color(0xFFF6F6F6);
  static const Color darkGray = Color(0xFF9F9F9F);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Highlight Colors
  static const Color highlightPrimary = Color(0xFF006FFD);
  static const Color highlightSecondary = Color(0xFF2897FF);
  static const Color highlightTertiary = Color(0xFF6FBAFF);
  static const Color highlightQuaternary = Color(0xFFB4DBFF);
  static const Color highlightQuintary = Color(0xFFEAF2FF);

  // Neutral Light Colors
  static const Color neutralLightPrimary = Color(0xFFC5C6CC);
  static const Color neutralLightSecondary = Color(0xFFD4D6DD);
  static const Color neutralLightTertiary = Color(0xFFE8E9F1);
  static const Color neutralLightQuaternary = Color(0xFFF8F9FE);
  static const Color neutralLightQuintary = Color(0xFFFFFFFF);

  // Neutral Dark Colors
  static const Color neutralDarkPrimary = Color(0xFF1F2024);
  static const Color neutralDarkSecondary = Color(0xFF2F3036);
  static const Color neutralDarkTertiary = Color(0xFF494A50);
  static const Color neutralDarkQuaternary = Color(0xFF71727A);
  static const Color neutralDarkQuintary = Color(0xFF8F9098);

  // Support Colors
  static const Color supportSuccessPrimary = Color(0xFF298267);
  static const Color supportSuccessSecondary = Color(0xFF3AC0A0);
  static const Color supportSuccessTertiary = Color(0xFFE7F4E8);

  static const Color supportWarningPrimary = Color(0xFFE86339);
  static const Color supportWarningSecondary = Color(0xFFFFB37C);
  static const Color supportWarningTertiary = Color(0xFFFFF4E4);

  static const Color supportErrorPrimary = Color(0xFFED3241);
  static const Color supportErrorSecondary = Color(0xFFFF616D);
  static const Color supportErrorTertiary = Color(0xFFFFE2E5);
}

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF10B981),
  onPrimary: Color(0xFF1F2024),
  surface: Color(0xFF2F3036),
  primaryContainer: Color(0xFF00766a),
  onPrimaryContainer: Color(0xFFFFFFFF),
  secondary: Color(0xFF00766a),
  onSecondary: Color(0xFF1F2024),
  secondaryContainer: Color(0xFF00766a),
  onSecondaryContainer: Color(0xFFFFFFFF),
  onSurface: Color(0xFFFFFFFF),
  error: Color(0xFFFF616D),
  onError: Color(0xFF1F2024),
  errorContainer: Color(0xFFED3241),
  onErrorContainer: Color(0xFFFFFFFF),
  outlineVariant: Color(0xFF8F9098),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF10B981),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF10B981),
  onPrimaryContainer: Color(0xFF10B981),
  secondary: Color(0xFF00766a),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF00766a),
  onSecondaryContainer: Color(0xFF00766a),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1F2024),
  error: Color(0xFFED3241),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFE2E5),
  onErrorContainer: Color(0xFF1F2024),
  outlineVariant: Color(0xFFC5C6CC),
);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
