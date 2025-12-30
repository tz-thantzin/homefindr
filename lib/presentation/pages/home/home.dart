import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/extensions/context_ex.dart';
import '../../widgets/desktop_nav_bar.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/mobile_drawer.dart';
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
          mobile: (context) => const MobileCompactNav(),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
          ],
        ),
      ),
    );
  }
}

class MobileCompactNav extends StatelessWidget {
  const MobileCompactNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.black.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.home_work, color: Colors.white, size: 30),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),
    );
  }
}