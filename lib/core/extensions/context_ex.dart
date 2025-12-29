
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

extension ContextX on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get sectionHeight =>
      MediaQuery.of(this).size.height - (isMobile ? 60 : 100);

  /// mobile < 780
  bool get isMobile => MediaQuery.of(this).size.width < 780;

  /// tablet >= 780 and < 1100
  bool get isTablet => screenWidth >= 780 && screenWidth < 1100;

  /// desktop >= 1100
  bool get isDesktop => MediaQuery.of(this).size.width >= 1100;

  double get appBarHeight => isMobile ? 60 : 100;

  AppLocalizations get localization => AppLocalizations.of(this)!;

  double percentWidth(double percent) => screenWidth * (percent / 100);
  double percentHeight(double percent) => screenHeight * (percent / 100);
  SizedBox percentSizedBox({double? pWidth, double? pHeight}) => SizedBox(
    width: percentWidth(pWidth ?? 0),
    height: percentHeight(pHeight ?? 0),
  );
}
