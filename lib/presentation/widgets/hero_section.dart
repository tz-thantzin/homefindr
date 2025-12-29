import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:homefindr/core/extensions/theme_ex.dart';
import '../../core/constants/constant_colors.dart';
import '../../core/constants/constant_data.dart';
import '../../core/constants/constant_sizes.dart';
import '../../core/extensions/context_ex.dart';
import 'search_bar_card.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Pre-cache images for smoother transitions
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % heroBgImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight,
      child: Stack(
        children: [
          // Background Image Layer with Crossfade
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: CachedNetworkImage(
                key: ValueKey<int>(_currentIndex),
                imageUrl: heroBgImages[_currentIndex],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(color: kBlack),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),

          // Dark Overlay Layer
          Positioned.fill(
            child: Container(
              color: kBlack.withValues(alpha: 0.4),
            ),
          ),

          // Content Layer
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "THE BEST WAY TO",
                  style: TextStyle(
                    color: kWhite,
                    letterSpacing: 2,
                    fontSize: tx14,
                    fontWeight: light,
                  ),
                ),
                const SizedBox(height: s20),
                Text(
                  "Find Your Dream Home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kWhite,
                    fontSize: context.isMobile ? tx36 : tx64,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: s10),
                const Text(
                  "We've more than 745,000 apartments, place & plot.",
                  style: TextStyle(color: kWhite, fontSize: tx18),
                ),
                const SizedBox(height: s50),
                const SearchBarCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}