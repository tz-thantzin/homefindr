import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_data.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/extensions/theme_ex.dart';
// theme_ex.dart exports: bold, semiBold, medium, light font weight constants
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
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
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
          // ── Background carousel ──
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1200),
              child: CachedNetworkImage(
                key: ValueKey<int>(_currentIndex),
                imageUrl: heroBgImages[_currentIndex],
                imageBuilder: (_, provider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (_, _) => Container(color: kSecondary),
                errorWidget: (_, _, _) => Container(color: kSecondary),
              ),
            ),
          ),

          // ── Deep luxury overlay (gradient, darker at bottom) ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kBlack.withValues(alpha: 0.55),
                    kBlack.withValues(alpha: 0.72),
                    kBlack.withValues(alpha: 0.82),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // ── Editorial content ──
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Eyebrow ──
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 32, height: 1, color: kPrimary),
                      const SizedBox(width: s12),
                      Text(
                        context.localization.the_best_way_to.toUpperCase(),
                        style: GoogleFonts.dmSans(
                          color: kPrimary,
                          letterSpacing: 3,
                          fontSize: tx12,
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(width: s12),
                      Container(width: 32, height: 1, color: kPrimary),
                    ],
                  ),

                  const SizedBox(height: s24),

                  // ── Main heading — Playfair Display italic ──
                  Text(
                    context.localization.find_dream_home,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: kCream,
                      fontSize: context.isMobile ? tx36 : tx64,
                      fontWeight: bold,
                      fontStyle: FontStyle.italic,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: s20),

                  // ── Thin gold ornamental rule ──
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 24, height: 1, color: kPrimary.withValues(alpha: 0.5)),
                      const SizedBox(width: s8),
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle)),
                      const SizedBox(width: s8),
                      Container(width: 24, height: 1, color: kPrimary.withValues(alpha: 0.5)),
                    ],
                  ),

                  const SizedBox(height: s20),

                  // ── Subtitle ──
                  Text(
                    context.localization.more_than_apartments,
                    style: GoogleFonts.dmSans(
                      color: kCream.withValues(alpha: 0.65),
                      fontSize: tx16,
                      fontWeight: light,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: s48),

                  // ── Search card ──
                  const SearchBarCard(),
                ],
              ),
            ),
          ),

          // ── Subtle bottom fade to canvas ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kSecondary.withValues(alpha: 0),
                    kSecondary,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
