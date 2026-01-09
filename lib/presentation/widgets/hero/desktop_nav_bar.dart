import 'package:flutter/material.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/extensions/theme_ex.dart';
import '../common/nav_logo.dart';

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s42),
      color: kBlack.withValues(alpha: 0.2),
      child: Row(
        children: [
          const NavLogo(),
          const SizedBox(width: s42),
          _navItem(context.localization.nav_home),
          _navItem(context.localization.nav_buy),
          _navItem(context.localization.nav_rent),
          _navItem(context.localization.nav_sell),
          const Spacer(),
          const Icon(Icons.person_outline, color: kWhite, size: s24),
          const SizedBox(width: s10),
          Text(
              context.localization.nav_login_register,
              style: TextStyle(
                color: kWhite,
                fontWeight: bold,
                fontSize: tx16,
              )
          ),
          const SizedBox(width: s20),
          _addPropertyButton(context),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: s16),
      child: Row(
        children: [
          Text(
              title,
              style: const TextStyle(
                color: kWhite,
                fontWeight: medium,
                fontSize: tx16,
              )
          ),
          const SizedBox(width: s10),
          const Icon(Icons.keyboard_arrow_down, color: kWhite, size: s16),
        ],
      ),
    );
  }

  Widget _addPropertyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s20, vertical: s14),
      decoration: BoxDecoration(
        border: Border.all(color: kWhite),
        borderRadius: BorderRadius.circular(s28), // Matches design curves
      ),
      child: Row(
        children: [
          Text(
            context.localization.nav_contact_us,
              style: const TextStyle(color: kWhite, fontSize: tx14)
          ),
          const SizedBox(width: s10),
          const Icon(Icons.north_east, color: kWhite, size: s14),
        ],
      ),
    );
  }
}
