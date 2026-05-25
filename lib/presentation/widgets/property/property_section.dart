import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/extensions/theme_ex.dart';
import '../../../core/router/app_router.dart';
import '../../view_models/property_view_model.dart';
import 'property_card.dart';

class PropertySection extends ConsumerStatefulWidget {
  const PropertySection({super.key});

  @override
  ConsumerState<PropertySection> createState() => _PropertySectionState();
}

class _PropertySectionState extends ConsumerState<PropertySection> {
  bool _startAnimation = false;

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(latestPropertiesViewModel(6));

    return Container(
      width: double.infinity,
      color: kCanvas,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Column(
        children: [
          // ── Section header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              children: [
                Text(
                  context.localization.property_discover_our_latest,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: tx42,
                    fontWeight: bold,
                    fontStyle: FontStyle.italic,
                    color: kCream,
                    height: 1.2,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: s16),

                // Gold ornamental rule
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 40, height: 1, color: kPrimary.withValues(alpha: 0.4)),
                    const SizedBox(width: s8),
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle)),
                    const SizedBox(width: s8),
                    Container(width: 40, height: 1, color: kPrimary.withValues(alpha: 0.4)),
                  ],
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                const SizedBox(height: s16),

                Text(
                  context.localization.property_explore_newest_listing,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(fontSize: tx16, color: kMuted, fontWeight: FontWeight.w400),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ),

          const SizedBox(height: s60),

          VisibilityDetector(
            key: const Key('property_grid'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction >= 0.35 && !_startAnimation) {
                setState(() => _startAnimation = true);
              }
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: propertiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: kPrimary)),
                error: (err, _) => Text(err.toString(), style: const TextStyle(color: kMuted)),
                data: (properties) => ScreenTypeLayout.builder(
                  desktop: (_) => _buildGrid(context, properties, 3),
                  tablet: (_) => _buildGrid(context, properties, 2),
                  mobile: (_) => _buildGrid(context, properties, 1),
                ),
              ),
            ),
          ),

          const SizedBox(height: s60),

          // ── "View all" CTA — luxury outlined gold button ──
          GestureDetector(
            onTap: () => context.goNamed(RouteName.buy),
            child: _LuxuryCTAButton(label: context.localization.property_view_all_properties_btn),
          )
              .animate(target: _startAnimation ? 1 : 0)
              .fadeIn(delay: 800.ms)
              .scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List properties, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: s20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: s24,
        mainAxisSpacing: s24,
        mainAxisExtent: 450,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final p = properties[index];
        final card = PropertyCard(
          imageUrl: p.imageUrl,
          title: p.title,
          location: p.location,
          price: p.price,
          status: p.status,
          beds: p.beds,
          baths: p.baths,
          sqft: p.sqft,
        );

        if (!_startAnimation) return Opacity(opacity: 0, child: card);

        return card
            .animate()
            .fadeIn(delay: (index * 200).ms, duration: 700.ms)
            .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

// ─────────────────────────────────────────────
// Luxury outlined CTA button
// ─────────────────────────────────────────────
class _LuxuryCTAButton extends StatefulWidget {
  final String label;
  const _LuxuryCTAButton({required this.label});

  @override
  State<_LuxuryCTAButton> createState() => _LuxuryCTAButtonState();
}

class _LuxuryCTAButtonState extends State<_LuxuryCTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: s32, vertical: s16),
        decoration: BoxDecoration(
          color: _hovered ? kPrimary : kTransparent,
          borderRadius: BorderRadius.circular(s2),
          border: Border.all(color: kPrimary, width: 1),
          boxShadow: _hovered
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 6))]
              : const [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.dmSans(
                color: _hovered ? kSecondary : kPrimary,
                fontSize: tx14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: s10),
            Icon(Icons.north_east, color: _hovered ? kSecondary : kPrimary, size: s16),
          ],
        ),
      ),
    );
  }
}
