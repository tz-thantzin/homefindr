import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/constants/constant_colors.dart';
import '../../core/constants/constant_images.dart';
import '../../core/constants/constant_sizes.dart';
import '../../core/extensions/context_ex.dart';
import '../../core/extensions/padding_ex.dart';
import '../../presentation/widgets/common/animated_slide_button.dart';

class NotFoundSection extends StatelessWidget {
  final VoidCallback onGoHome;

  const NotFoundSection({required this.onGoHome, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite, // Ensuring background is explicitly white
      body: ScreenTypeLayout.builder(
        mobile: (context) => _buildMobileLayout(context),
        desktop: (context) => _buildDesktopLayout(context),
      ),
    );
  }

  // --- Mobile Layout ---
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: context.screenHeight),
        padding: context.defaultPagePadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: context.appBarHeight),

            // Large Watermark 404 (Subtle light grey)
            Text(
              '404',
              style: GoogleFonts.poppins(
                fontSize: tx96,
                fontWeight: FontWeight.bold,
                color: kGrey500.withValues(alpha: 0.5),
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: s32),

            // Illustration
            Image.asset(
              kPageNotFound,
              height: context.screenHeight * 0.3,
              fit: BoxFit.contain,
            ).animate(delay: 200.ms).fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),

            const SizedBox(height: s48),

            // Title
            Text(
              context.localization.page_not_found,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: tx24,
                fontWeight: FontWeight.w700,
                color: kSecondary, // Deep navy/dark blue
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),

            const SizedBox(height: s16),

            // Description
            Text(
              context.localization.the_page_you_are_looking_for_does_not_exist,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: tx16, fontWeight: FontWeight.normal, color: kGrey900),
            ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

            const SizedBox(height: s64),

            // Action Button
            AnimatedSlideButton(
              title: context.localization.go_back_home,
              width: s150,
              onPressed: onGoHome,
            ).animate(delay: 800.ms).fadeIn().scale(curve: Curves.easeOutBack),

            const SizedBox(height: s48),
          ],
        ),
      ),
    );
  }

  // --- Desktop Layout ---
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        padding: const EdgeInsets.all(s48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Side: Text and Content
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large 404 Watermark
                  Text(
                    '404',
                    style: GoogleFonts.poppins(
                      color: kGrey500.withValues(alpha: 0.7),
                      fontSize: 160,
                      letterSpacing: 8,
                      height: 0.9,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

                  const SizedBox(height: s32),

                  // Title
                  Text(
                    context.localization.page_not_found,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(fontSize: tx32, fontWeight: FontWeight.w800, color: kSecondary),
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: s24),

                  // Description
                  Text(
                    context.localization.the_page_you_are_looking_for_does_not_exist,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(fontSize: tx18, fontWeight: FontWeight.normal, color: kGrey1000),
                  ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: s48),

                  AnimatedSlideButton(
                    title: context.localization.go_back_home,
                    width: s150,
                    onPressed: onGoHome,
                  ).animate(delay: 700.ms).fadeIn().scale(curve: Curves.easeOutBack, alignment: Alignment.centerLeft),
                ],
              ),
            ),

            const SizedBox(width: s80),

            // Right Side: Large Illustration
            Expanded(
              flex: 6,
              child: Image.asset(kPageNotFound, fit: BoxFit.contain)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .fadeIn(duration: 1000.ms)
                  .shimmer(delay: 1200.ms, duration: 1800.ms, color: kGrey100.withValues(alpha: 0.2))
                  .moveY(begin: 10, end: -10, duration: 2.seconds, curve: Curves.easeInOut),
            ),
          ],
        ),
      ),
    );
  }
}
