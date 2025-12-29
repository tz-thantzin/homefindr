import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/constants/constant_colors.dart';
import '../../core/constants/constant_sizes.dart';
import '../../core/extensions/theme_ex.dart';



class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s42), // Used s42 for padding
      color: kBlack.withValues(alpha: 0.2),
      child: Row(
        children: [
          const _Logo(),
          const SizedBox(width: s42),
          _navItem("Home"),
          _navItem("Listings"),
          _navItem("Members"),
          _navItem("Blog"),
          _navItem("Pages"),
          const Spacer(),
          const Icon(Icons.person_outline, color: kWhite, size: s24),
          const SizedBox(width: s10),
          const Text(
              "Login / Register",
              style: TextStyle(
                color: kWhite,
                fontWeight: bold,
                fontSize: tx16,
              )
          ),
          const SizedBox(width: s20),
          _addPropertyButton(),
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

  Widget _addPropertyButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s20, vertical: s14),
      decoration: BoxDecoration(
        border: Border.all(color: kWhite),
        borderRadius: BorderRadius.circular(s28), // Matches design curves
      ),
      child: const Row(
        children: [
          Text(
              "Add Property",
              style: TextStyle(
                color: kWhite,
                fontSize: tx14,  
              )
          ),
          SizedBox(width: s10),
          Icon(Icons.north_east, color: kWhite, size: s14),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(s10),
          decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
          child: const Icon(Icons.home, color: kWhite, size: s20),
        ),
        const SizedBox(width: s10),
        const Text(
            "homez",
            style: TextStyle(
              color: kWhite,
              fontSize: tx24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            )
        ),
      ],
    );
  }
}