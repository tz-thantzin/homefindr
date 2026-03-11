import 'package:flutter/material.dart';

import '../../../core/constants/constant_colors.dart';
import '../common/nav_logo.dart';

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({super.key});

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar> {
  bool _isScrolled = false;
  ScrollController? _scrollController;

  void _onScroll() {
    final scrolled = (_scrollController?.offset ?? 0) > 50;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController?.removeListener(_onScroll);
    _scrollController = PrimaryScrollController.of(context);
    _scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _isScrolled ? kSecondary.withValues(alpha: 0.97) : kBlack.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NavLogo(),
          IconButton(
              icon: const Icon(Icons.menu, color: kWhite, size: 26),
              onPressed: () => Scaffold.of(context).openDrawer()
          ),
        ],
      ),
    );
  }
}