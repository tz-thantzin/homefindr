import 'package:flutter/material.dart';

import '../constants/constant_sizes.dart';
import 'context_ex.dart';


extension PaddingEX on BuildContext {
  EdgeInsetsGeometry defaultPagePadding() {
    final bool isDesktop = this.isDesktop;
    final double padding = isDesktop ? s64 : s32;

    return EdgeInsets.symmetric(
      horizontal: isDesktop ? padding : padding * 0.8,
      vertical: isDesktop ? padding : padding * 0.8,
    );
  }

  EdgeInsetsGeometry appbarPadding() {
    final bool isDesktop = this.isDesktop;
    final double horizontalPadding = isDesktop ? s50 : s20;

    return EdgeInsets.symmetric(
      horizontal: isDesktop ? horizontalPadding : horizontalPadding * 0.8,
      vertical: isDesktop ? 28 : 20,
    );
  }
}