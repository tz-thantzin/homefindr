import 'package:flutter/material.dart';

import '../../../../core/constants/constant_colors.dart';
import '../../../../core/extensions/context_ex.dart';
import 'property_listing.dart';

class BuyScreen extends StatelessWidget {
  final String initialType;

  const BuyScreen({super.key, this.initialType = ''});

  @override
  Widget build(BuildContext context) {
    return PropertyListingScreen(
      status: context.localization.buy_screen_status,
      heroImage: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80',
      heroTitle: context.localization.buy_hero_title,
      heroSubtitle: context.localization.buy_hero_subtitle,
      accentColor: kPrimary,
      initialType: initialType,
    );
  }
}
