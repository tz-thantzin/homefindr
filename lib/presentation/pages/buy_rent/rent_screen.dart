import 'package:flutter/material.dart';

import '../../../../core/constants/constant_colors.dart';
import '../../../../core/extensions/context_ex.dart';
import 'property_listing.dart';

class RentScreen extends StatelessWidget {
  final String initialType;

  const RentScreen({super.key, this.initialType = ''});

  @override
  Widget build(BuildContext context) {
    return PropertyListingScreen(
      status: context.localization.rent_screen_status,
      heroImage: 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1920&q=80',
      heroTitle: context.localization.rent_hero_title,
      heroSubtitle: context.localization.rent_hero_subtitle,
      accentColor: kSecondary,
      initialType: initialType,
    );
  }
}
