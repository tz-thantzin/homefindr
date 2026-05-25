import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_images.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../view_models/subscription_view_model.dart';

class SubscriptionSection extends ConsumerWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isYearly = ref.watch(billingCycleProvider);

    return Container(
      width: double.infinity,
      color: kCanvas,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s48),
          child: Column(
            children: [
              // ── Header ──
              Text(
                context.localization.subscription_section_title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: tx48,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: kCream,
                  height: 1.2,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),

              const SizedBox(height: s16),

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
                context.localization.subscription_section_subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: tx16, color: kMuted),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: s40),

              _BillingToggle(isYearly: isYearly),

              const SizedBox(height: s48),

              ScreenTypeLayout.builder(
                mobile: (context) => _buildVerticalLayout(context, isYearly),
                tablet: (context) => _buildHorizontalLayout(context, isYearly),
                desktop: (context) => _buildHorizontalLayout(context, isYearly),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, bool isYearly) {
    return Column(
      children: [
        _PricingCard(
          title: context.localization.subscription_section_basic_title,
          price: isYearly ? "99" : "9",
          iconPath: kIconBasic,
          features: [
            context.localization.subscription_section_basic_feature_1,
            context.localization.subscription_section_basic_feature_2,
            context.localization.subscription_section_basic_feature_3,
          ],
          isExpanded: false,
        ),
        const SizedBox(height: s24),
        _PricingCard(
          title: context.localization.subscription_section_business_title,
          price: isYearly ? "290" : "29",
          iconPath: kIconBusiness,
          features: [
            context.localization.subscription_section_business_feature_1,
            context.localization.subscription_section_business_feature_2,
            context.localization.subscription_section_business_feature_3,
            context.localization.subscription_section_business_feature_4,
          ],
          isPopular: true,
          isExpanded: false,
        ),
        const SizedBox(height: s24),
        _PricingCard(
          title: context.localization.subscription_section_pro_title,
          price: isYearly ? "590" : "59",
          iconPath: kIconPro,
          features: [
            context.localization.subscription_section_pro_feature_1,
            context.localization.subscription_section_pro_feature_2,
            context.localization.subscription_section_pro_feature_3,
            context.localization.subscription_section_pro_feature_4,
          ],
          isExpanded: false,
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, bool isYearly) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _PricingCard(
              title: context.localization.subscription_section_basic_title,
              price: isYearly ? "99" : "9",
              iconPath: kIconBasic,
              features: [
                context.localization.subscription_section_basic_feature_1,
                context.localization.subscription_section_basic_feature_2,
                context.localization.subscription_section_basic_feature_3,
              ],
              isExpanded: true,
            ),
          ),
          const SizedBox(width: s20),
          Expanded(
            child: _PricingCard(
              title: context.localization.subscription_section_business_title,
              price: isYearly ? "290" : "29",
              iconPath: kIconBusiness,
              features: [
                context.localization.subscription_section_business_feature_1,
                context.localization.subscription_section_business_feature_2,
                context.localization.subscription_section_business_feature_3,
                context.localization.subscription_section_business_feature_4,
              ],
              isPopular: true,
              isExpanded: true,
            ),
          ),
          const SizedBox(width: s20),
          Expanded(
            child: _PricingCard(
              title: context.localization.subscription_section_pro_title,
              price: isYearly ? "590" : "59",
              iconPath: kIconPro,
              features: [
                context.localization.subscription_section_pro_feature_1,
                context.localization.subscription_section_pro_feature_2,
                context.localization.subscription_section_pro_feature_3,
                context.localization.subscription_section_pro_feature_4,
              ],
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Billing Toggle
// ─────────────────────────────────────────────
class _BillingToggle extends ConsumerWidget {
  final bool isYearly;
  const _BillingToggle({required this.isYearly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(s4),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(s4),
        border: Border.all(color: kBorderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: context.localization.subscription_section_monthly,
            isActive: !isYearly,
            onTap: () => ref.read(billingCycleProvider.notifier).state = false,
          ),
          _ToggleButton(
            label: context.localization.subscription_section_yearly,
            isActive: isYearly,
            onTap: () => ref.read(billingCycleProvider.notifier).state = true,
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s12),
        decoration: BoxDecoration(
          color: isActive ? kPrimary : kTransparent,
          borderRadius: BorderRadius.circular(s2),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: tx14,
            fontWeight: FontWeight.w600,
            color: isActive ? kSecondary : kMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pricing Card
// ─────────────────────────────────────────────
class _PricingCard extends StatefulWidget {
  final String title;
  final String price;
  final String iconPath;
  final List<String> features;
  final bool isPopular;
  final bool isExpanded;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.iconPath,
    required this.features,
    this.isPopular = false,
    this.isExpanded = true,
  });

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isPopular || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(s28),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(s4),
          border: Border.all(
            color: isHighlighted ? kPrimary.withValues(alpha: 0.7) : kBorderDark,
            width: isHighlighted ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isHighlighted
                  ? kPrimary.withValues(alpha: 0.12)
                  : kBlack.withValues(alpha: 0.3),
              blurRadius: isHighlighted ? 32 : 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Popular badge
            if (widget.isPopular)
              Container(
                margin: const EdgeInsets.only(bottom: s16),
                padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s4),
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(s2),
                  border: Border.all(color: kPrimary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  context.localization.subscription_section_most_popular,
                  style: GoogleFonts.dmSans(
                    fontSize: tx12,
                    fontWeight: FontWeight.w700,
                    color: kPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            else
              const SizedBox(height: s4),

            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: tx22,
                          fontWeight: FontWeight.bold,
                          color: kCream,
                        ),
                      ),
                      const SizedBox(height: s8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${widget.price}",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: tx42,
                                fontWeight: FontWeight.bold,
                                color: kPrimary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: s10, left: s6),
                              child: Text(
                                context.localization.subscription_section_per_month,
                                style: GoogleFonts.dmSans(fontSize: tx14, color: kMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: s8),
                Image.asset(
                  widget.iconPath,
                  width: s52,
                  height: s52,
                  errorBuilder: (context, error, stack) =>
                      Icon(Icons.star, size: s52, color: kPrimary),
                ),
              ],
            ),

            const SizedBox(height: s28),
            Container(height: 1, color: kDividerDark),
            const SizedBox(height: s28),

            // Features
            ...widget.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: s14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(s2),
                      ),
                      child: const Icon(Icons.check, size: 12, color: kPrimary),
                    ),
                    const SizedBox(width: s12),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.dmSans(fontSize: tx14, color: kMuted, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.isExpanded) const Spacer() else const SizedBox(height: s28),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isPopular ? kPrimary : kTransparent,
                  foregroundColor: widget.isPopular ? kSecondary : kPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: s18),
                  side: BorderSide(color: kPrimary, width: widget.isPopular ? 0 : 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(s2)),
                ),
                child: Text(
                  context.localization.subscription_section_get_started,
                  style: GoogleFonts.dmSans(
                    fontSize: tx14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

