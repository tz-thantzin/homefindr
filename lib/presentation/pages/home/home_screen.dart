import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:homefindr/presentation/widgets/subscription/subscription_section.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/extensions/context_ex.dart';
import '../../widgets/common/nav_logo.dart';
import '../../widgets/footer/footer_section.dart';
import '../../widgets/hero/desktop_nav_bar.dart';
import '../../widgets/hero/hero_section.dart';
import '../../widgets/hero/mobile_drawer.dart';
import '../../widgets/property/property_section.dart';
import '../../widgets/property_type/property_type_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: context.isDesktop ? null : const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ScreenTypeLayout.builder(
          desktop: (context) => const DesktopNavBar(),
          mobile: (context) => const _MobileScrollNavBar(),
        ),
      ),
      body: const SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            HeroSection(),
            PropertySection(),
            PropertyTypeSection(),
            SubscriptionSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Scroll-aware mobile nav bar
// ─────────────────────────────────────────────
class _MobileScrollNavBar extends StatefulWidget {
  const _MobileScrollNavBar();

  @override
  State<_MobileScrollNavBar> createState() => _MobileScrollNavBarState();
}

class _MobileScrollNavBarState extends State<_MobileScrollNavBar> {
  bool _isScrolled = false;

  void _onScroll() {
    final scrolled = PrimaryScrollController.of(context).offset > 50;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(_onScroll);
  }

  @override
  void dispose() {
    PrimaryScrollController.of(context).removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _isScrolled
          ? const Color(0xFF1D293F).withValues(alpha: 0.97)
          : Colors.black.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NavLogo()
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.2, end: 0),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
        ],
      ),
    );
  }
}