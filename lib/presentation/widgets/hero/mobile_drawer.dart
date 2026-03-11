import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../common/nav_logo.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState
        .of(context)
        .uri
        .path;

    return Drawer(
      backgroundColor: kSecondary,
      width: context.percentWidth(80),
      child: Column(
        children: [
          _buildDrawerHeader(context),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: s16),
              children: [
                _AnimatedDrawerLink(
                  index: 0,
                  title: context.localization.nav_home,
                  icon: Icons.home_outlined,
                  routeName: RouteName.home,
                  routePath: RoutePath.initial,
                  currentPath: currentPath,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteName.home);
                  },
                ),
                _AnimatedDrawerLink(
                  index: 1,
                  title: context.localization.nav_buy,
                  icon: Icons.sell_outlined,
                  routeName: RouteName.buy,
                  routePath: RoutePath.buy,
                  currentPath: currentPath,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteName.buy);
                  },
                ),
                _AnimatedDrawerLink(
                  index: 2,
                  title: context.localization.nav_rent,
                  icon: Icons.key_outlined,
                  routeName: RouteName.rent,
                  routePath: RoutePath.rent,
                  currentPath: currentPath,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteName.rent);
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: s20, vertical: s12),
                  child: Divider(color: Colors.white12),
                ),

                // Language selector in drawer
                _LanguageTiles(),
              ],
            ),
          ),

          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top + s20,
        bottom: s20,
        left: s20,
        right: s8,
      ),
      decoration: BoxDecoration(
        color: kBlack.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: kWhite.withValues(alpha: 0.08))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NavLogo(),
          IconButton(
            icon: const Icon(Icons.close, color: kWhite),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(s20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: kWhite.withValues(alpha: 0.08))),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline, color: kWhite),
            title: Text(
              context.localization.nav_login_register,
              style: const TextStyle(color: kWhite, fontWeight: FontWeight.w600),
            ),
            onTap: () {},
          ),
          const SizedBox(height: s10),
          SizedBox(
            width: double.infinity,
            height: s55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.goNamed(RouteName.contact);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(s12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.localization.nav_contact_us, style: const TextStyle(color: kWhite, fontSize: tx14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: s8),
                  const Icon(Icons.call, size: s16, color: kWhite),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated Drawer Link
// ─────────────────────────────────────────────
class _AnimatedDrawerLink extends StatefulWidget {
  final int index;
  final String title;
  final IconData icon;
  final String routeName;
  final String routePath;
  final String currentPath;
  final VoidCallback onTap;

  const _AnimatedDrawerLink({
    required this.index,
    required this.title,
    required this.icon,
    required this.routeName,
    required this.routePath,
    required this.currentPath,
    required this.onTap,
  });

  @override
  State<_AnimatedDrawerLink> createState() => _AnimatedDrawerLinkState();
}

class _AnimatedDrawerLinkState extends State<_AnimatedDrawerLink> {
  bool _hovered = false;

  bool get _isActive => widget.currentPath == widget.routePath;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: s12, vertical: s4),
          padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s14),
          decoration: BoxDecoration(
            color: _isActive
                ? kPrimary.withValues(alpha: 0.15)
                : _hovered
                ? kWhite.withValues(alpha: 0.05)
                : kTransparent,
            borderRadius: BorderRadius.circular(s12),
            border: _isActive
                ? Border.all(color: kPrimary.withValues(alpha: 0.3))
                : Border.all(color: kTransparent),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isActive
                      ? kPrimary.withValues(alpha: 0.2)
                      : kWhite.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(s8),
                ),
                child: Icon(
                  widget.icon,
                  size: s18,
                  color: _isActive ? kPrimary : kWhite.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: s12),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: _isActive ? kWhite : kWhite.withValues(alpha: 0.75),
                    fontWeight: _isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: tx16,
                  ),
                ),
              ),
              if (_isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.index * 80 + 100), duration: 400.ms)
        .slideX(begin: -0.15, end: 0, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────
// Language tiles inside drawer
// ─────────────────────────────────────────────
class _LanguageTiles extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LanguageTiles> createState() => _LanguageTilesState();
}

class _LanguageTilesState extends ConsumerState<_LanguageTiles> {

  final List<Map<String, String>> _langs = [
    {'flag': '🇺🇸', 'code': 'EN', 'label': 'English'},
    {'flag': '🇲🇲', 'code': 'MY', 'label': 'မြန်မာ'},
    {'flag': '🇹🇭', 'code': 'TH', 'label': 'ภาษาไทย'},
    {'flag': '🇨🇳', 'code': 'ZH', 'label': '中文'},
    {'flag': '🇯🇵', 'code': 'JA', 'label': '日本語'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.nav_language.toUpperCase(),
            style: TextStyle(
              color: kWhite.withValues(alpha: 0.35),
              fontSize: tx12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: s12),
          Wrap(
            spacing: s8,
            runSpacing: s8,
            children: _langs.map((lang) {
              final isSelected = ref
                  .watch(localeProvider)
                  .languageCode
                  .toUpperCase() == lang['code'];
              return GestureDetector(
                onTap: () => ref.read(localeProvider.notifier).setByCode(lang['code']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s8),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimary : kWhite.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(s20),
                    border: Border.all(
                      color: isSelected ? kPrimary : kWhite.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    '${lang['flag']} ${lang['code']}',
                    style: TextStyle(
                      color: isSelected ? kWhite : kWhite.withValues(alpha: 0.65),
                      fontSize: tx12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}