import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/constant_colors.dart';
import '../../core/constants/constant_sizes.dart';
import '../../core/extensions/context_ex.dart';
import '../../core/extensions/theme_ex.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kWhite,
      width: context.percentWidth(s80),
      child: Column(
        children: [
          // Drawer Header with Logo
          _buildDrawerHeader(context),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: s20),
              children: [
                _DrawerLink(
                  title: context.localization.nav_home,
                  onTap: () => context.go('/'),
                  hasDropdown: true,
                ),
                _DrawerLink(
                  title: context.localization.nav_buy,
                  onTap: () {},
                  hasDropdown: true,
                ),
                _DrawerLink(
                  title: context.localization.nav_rent,
                  onTap: () {},
                  hasDropdown: true,
                ),
                _DrawerLink(
                  title: context.localization.nav_sell,
                  onTap: () {},
                  hasDropdown: true,
                ),
              ],
            ),
          ),

          // Footer Actions (Login & Add Property)
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: s20,
        left: s20,
        right: s20,
      ),
      decoration: const BoxDecoration(
        color: kGrey100,
        border: Border(bottom: BorderSide(color: kBlack12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(s8),
                decoration: const BoxDecoration(
                  color: kPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home, color: kWhite, size: s18),
              ),
              const SizedBox(width: s10),
              Text(
                "homez",
                style: context.labelLarge.copyWith(color: kBlack),
              ),
            ],
          ),
          // Close Button
          IconButton(
            icon: const Icon(Icons.close, color: kBlack),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(s20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kBlack12)),
      ),
      child: Column(
        children: [
          // Login/Register
          ListTile(
            leading: const Icon(Icons.person_outline, color: kBlack),
            title: Text(context.localization.nav_login_register, style: context.bodyLarge),
            onTap: () {},
          ),
          const SizedBox(height: s10),
          // Add Property Button
          SizedBox(
            width: double.infinity,
            height: s55,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(s12),
                ),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.localization.nav_contact_us),
                  SizedBox(width: s10),
                  Icon(Icons.call, size: s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool hasDropdown;

  const _DrawerLink({
    required this.title,
    required this.onTap,
    this.hasDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: s25, vertical: s5),
      title: Text(
        title,
        style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: hasDropdown
          ? const Icon(Icons.chevron_right, size: s18, color: kGrey500)
          : null,
      onTap: onTap,
    );
  }
}