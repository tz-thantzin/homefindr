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
      scaffoldBackgroundColor: kSecondary,
      appBarTheme: appBarTheme,
      textTheme: textTheme,
      textSelectionTheme: textSelectionTheme,
      colorScheme: colorScheme,
      iconTheme: iconTheme,
      highlightColor: kTransparent,
      focusColor: kPrimary,
      inputDecorationTheme: inputDecorationTheme,
      dividerColor: kDividerDark,
      drawerTheme: const DrawerThemeData(backgroundColor: kCanvas),
      popupMenuTheme: const PopupMenuThemeData(color: kSurface),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          fillColor: kSurface,
          filled: true,
        ),
      ),
    );
  }

  AppBarTheme get appBarTheme {
    return AppBarTheme(
      backgroundColor: kTransparent,
      elevation: 0,
      toolbarHeight: s100,
      centerTitle: false,
      titleTextStyle: labelLarge.copyWith(fontWeight: bold, color: kCream),
      foregroundColor: kCream,
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
      // Playfair Display for editorial display / headline / title
      displayLarge: GoogleFonts.playfairDisplay(fontSize: s96, fontWeight: semiBold, color: kCream),
      displayMedium: GoogleFonts.playfairDisplay(fontSize: s70, fontWeight: semiBold, color: kCream),
      displaySmall: GoogleFonts.playfairDisplay(fontSize: s60, fontWeight: bold, color: kCream),
      headlineLarge: GoogleFonts.playfairDisplay(fontSize: s100, fontWeight: semiBold, color: kCream),
      headlineMedium: GoogleFonts.playfairDisplay(fontSize: s80, fontWeight: semiBold, color: kCream),
      headlineSmall: GoogleFonts.playfairDisplay(fontSize: s64, fontWeight: bold, color: kCream),
      titleLarge: GoogleFonts.playfairDisplay(fontSize: s48, fontWeight: bold, color: kCream),
      titleMedium: GoogleFonts.playfairDisplay(fontSize: s42, fontWeight: bold, color: kCream),
      titleSmall: GoogleFonts.playfairDisplay(fontSize: s36, fontWeight: bold, color: kCream),
      // DM Sans for body text
      bodyLarge: GoogleFonts.dmSans(fontSize: s16, fontWeight: medium, color: kMuted),
      bodyMedium: GoogleFonts.dmSans(fontSize: s14, fontWeight: medium, color: kMuted),
      bodySmall: GoogleFonts.dmSans(fontSize: s10, fontWeight: medium, color: kMuted),
      labelLarge: GoogleFonts.dmSans(fontSize: s28, fontWeight: bold, color: kCream),
      labelMedium: GoogleFonts.dmSans(fontSize: s24, fontWeight: semiBold, color: kCream),
      labelSmall: GoogleFonts.dmSans(fontSize: s20, fontWeight: semiBold, color: kCream),
    );
  }

  TextSelectionThemeData get textSelectionTheme {
    return const TextSelectionThemeData(
      cursorColor: kPrimary,
      selectionColor: kGrey1200,
      selectionHandleColor: kPrimary,
    );
  }

  IconThemeData get iconTheme {
    return const IconThemeData(color: kCream);
  }

  ColorScheme get colorScheme {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: kPrimary,
      onPrimary: kSecondary,
      secondary: kCanvas,
      onSecondary: kCream,
      error: kRed,
      onError: kWhite,
      surface: kSurface,
      onSurface: kCream,
    );
  }

  /// ---------------- Text Styles (direct use) ----------------

  TextStyle get displayLarge =>
      GoogleFonts.playfairDisplay(fontSize: s96, fontWeight: semiBold, color: kCream);
  TextStyle get displayMedium =>
      GoogleFonts.playfairDisplay(fontSize: s70, fontWeight: semiBold, color: kCream);
  TextStyle get displaySmall =>
      GoogleFonts.playfairDisplay(fontSize: s60, fontWeight: bold, color: kCream);

  TextStyle get headlineLarge =>
      GoogleFonts.playfairDisplay(fontSize: s100, fontWeight: semiBold, color: kCream);
  TextStyle get headlineMedium =>
      GoogleFonts.playfairDisplay(fontSize: s80, fontWeight: semiBold, color: kCream);
  TextStyle get headlineSmall =>
      GoogleFonts.playfairDisplay(fontSize: s64, fontWeight: bold, color: kCream);

  TextStyle get titleLarge =>
      GoogleFonts.playfairDisplay(fontSize: s48, fontWeight: bold, color: kCream);
  TextStyle get titleMedium =>
      GoogleFonts.playfairDisplay(fontSize: s42, fontWeight: bold, color: kCream);
  TextStyle get titleSmall =>
      GoogleFonts.playfairDisplay(fontSize: s36, fontWeight: bold, color: kCream);

  TextStyle get labelLarge =>
      GoogleFonts.dmSans(fontSize: s28, fontWeight: bold, color: kCream);
  TextStyle get labelMedium =>
      GoogleFonts.dmSans(fontSize: s24, fontWeight: semiBold, color: kCream);
  TextStyle get labelSmall =>
      GoogleFonts.dmSans(fontSize: s20, fontWeight: semiBold, color: kCream);

  TextStyle get bodyLarge =>
      GoogleFonts.dmSans(fontSize: s16, fontWeight: medium, color: kMuted);
  TextStyle get bodyMedium =>
      GoogleFonts.dmSans(fontSize: s14, fontWeight: medium, color: kMuted);
  TextStyle get bodySmall =>
      GoogleFonts.dmSans(fontSize: s10, fontWeight: medium, color: kMuted);
}
