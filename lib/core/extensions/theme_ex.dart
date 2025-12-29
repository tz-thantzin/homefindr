import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant_colors.dart';
import '../constants/constant_sizes.dart';

/// ---------------- Font Weights ----------------
const superBold = FontWeight.w900;
const bold = FontWeight.w700;
const semiBold = FontWeight.w600;
const medium = FontWeight.w500;
const light = FontWeight.w300;

extension ThemeEx on BuildContext {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kWhite,
      appBarTheme: appBarTheme,
      textTheme: GoogleFonts.robotoTextTheme(textTheme),
      textSelectionTheme: textSelectionTheme,
      colorScheme: colorScheme,
      iconTheme: iconTheme,
      highlightColor: kTransparent,
      focusColor: kPrimary,
      inputDecorationTheme: inputDecorationTheme,
    );
  }

  AppBarTheme get appBarTheme {
    return AppBarTheme(
      backgroundColor: kTransparent,
      elevation: 0,
      toolbarHeight: s100,
      centerTitle: false,
      titleTextStyle: labelLarge.copyWith(fontWeight: bold, color: kWhite),
      foregroundColor: kWhite,
    );
  }

  InputDecorationTheme get inputDecorationTheme {
    return const InputDecorationTheme(
      filled: true,
      fillColor: kTransparent,
      alignLabelWithHint: true,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }

  TextTheme get textTheme {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ).apply(
      bodyColor: kBlack,
      displayColor: kBlack,
    );
  }

  TextSelectionThemeData get textSelectionTheme {
    return const TextSelectionThemeData(
      cursorColor: kPrimary,
      selectionColor: kGrey500,
      selectionHandleColor: kPrimary,
    );
  }

  IconThemeData get iconTheme {
    return const IconThemeData(color: kBlack);
  }

  ColorScheme get colorScheme {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: kPrimary,
      onPrimary: kWhite,
      secondary: kSecondary,
      onSecondary: kWhite,
      error: kRed,
      onError: kWhite,
      surface: kGrey100,
      onSurface: kBlack,
    );
  }

  /// ---------------- Text Styles ----------------

  TextStyle get displayLarge =>
      const TextStyle(fontSize: s96, fontWeight: semiBold);
  TextStyle get displayMedium =>
      const TextStyle(fontSize: s70, fontWeight: semiBold);
  TextStyle get displaySmall =>
      const TextStyle(fontSize: s60, fontWeight: bold);

  TextStyle get headlineLarge =>
      const TextStyle(fontSize: s100, fontWeight: semiBold);
  TextStyle get headlineMedium =>
      const TextStyle(fontSize: s80, fontWeight: semiBold);
  TextStyle get headlineSmall =>
      const TextStyle(fontSize: s64, fontWeight: bold);

  TextStyle get titleLarge => const TextStyle(fontSize: s48, fontWeight: bold);
  TextStyle get titleMedium => const TextStyle(fontSize: s42, fontWeight: bold);
  TextStyle get titleSmall => const TextStyle(fontSize: s36, fontWeight: bold);

  TextStyle get labelLarge => const TextStyle(fontSize: s28, fontWeight: bold);
  TextStyle get labelMedium =>
      const TextStyle(fontSize: s24, fontWeight: semiBold);
  TextStyle get labelSmall =>
      const TextStyle(fontSize: s20, fontWeight: semiBold);

  TextStyle get bodyLarge =>
      const TextStyle(fontSize: s16, fontWeight: medium, color: kBlack);
  TextStyle get bodyMedium =>
      const TextStyle(fontSize: s14, fontWeight: medium, color: kBlack);
  TextStyle get bodySmall =>
      const TextStyle(fontSize: s10, fontWeight: medium);
}