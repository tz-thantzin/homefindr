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
    // Watch the billing cycle state directly using the provided ref
    final isYearly = ref.watch(billingCycleProvider);

    return Container(
      width: double.infinity,
      color: kWhite,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s64),
            child: Column(
              children: [
                // Header
                Text(
                  context.localization.subscription_section_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: tx48,
                    fontWeight: FontWeight.bold,
                    color: kSecondary,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),

                const SizedBox(height: s16),

                Text(
                  context.localization.subscription_section_subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: tx16, color: const Color(0xFF64748B)),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: s40),

                // Toggle
                _BillingToggle(isYearly: isYearly),

                const SizedBox(height: s48),

                // Grid - Uses ScreenTypeLayout for responsive switching
                ScreenTypeLayout.builder(
                  mobile: (context) => _buildVerticalLayout(context, isYearly),
                  tablet: (context) => _buildHorizontalLayout(context, isYearly),
                  desktop: (context) => _buildHorizontalLayout(context, isYearly),
                ),
              ],
            ),
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
          isPopular: false,
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
          isPopular: false,
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
          const SizedBox(width: s24),
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
          const SizedBox(width: s24),
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

class _BillingToggle extends ConsumerWidget {
  final bool isYearly;
  const _BillingToggle({required this.isYearly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(s4),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s32),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s12),
        decoration: BoxDecoration(color: isActive ? kPrimary : kTransparent, borderRadius: BorderRadius.circular(s32)),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: tx14,
            fontWeight: FontWeight.w600,
            color: isActive ? kWhite : const Color(0xFF64748B),
          ),
        ),
      ).animate(target: isActive ? 1 : 0).tint(color: kPrimary.withValues(alpha: 0.1)),
    );
  }
}

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
    final accentColor = kPrimary;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallCard = screenWidth < 400;
    final double currentIconSize = isSmallCard ? s48 : s64;
    final double horizontalPadding = isSmallCard ? s16 : s32;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child:
          AnimatedContainer(
                duration: 300.ms,
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: s32),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(s24),
                  border: Border.all(
                    color: _isHovered ? accentColor : const Color(0xFFE2E8F0),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered ? accentColor.withValues(alpha: 0.1) : kBlack.withValues(alpha: 0.03),
                      blurRadius: _isHovered ? 30 : 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Popular Tag Placeholder
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s4),
                      decoration: BoxDecoration(
                        color: widget.isPopular ? accentColor.withValues(alpha: .1) : kTransparent,
                        borderRadius: BorderRadius.circular(s12),
                      ),
                      child: Text(
                        context.localization.subscription_section_most_popular,
                        style: GoogleFonts.inter(
                          fontSize: tx12,
                          fontWeight: FontWeight.bold,
                          color: widget.isPopular ? accentColor : kTransparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: s16),

                    // Header Row
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
                                style: GoogleFonts.poppins(
                                  fontSize: tx24,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondary,
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
                                      style: GoogleFonts.poppins(
                                        fontSize: tx48,
                                        fontWeight: FontWeight.bold,
                                        color: kSecondary,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: s12, left: s4),
                                      child: Text(
                                        context.localization.subscription_section_per_month,
                                        style: GoogleFonts.inter(fontSize: tx16, color: const Color(0xFF64748B)),
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
                          width: currentIconSize,
                          height: currentIconSize,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.star, size: currentIconSize, color: accentColor),
                        ),
                      ],
                    ),

                    const SizedBox(height: s32),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: s32),

                    // Features List
                    ...widget.features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: s16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: s20, color: accentColor),
                            const SizedBox(width: s12),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.inter(fontSize: tx14, color: const Color(0xFF475569)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Conditional spacer: only used when intrinsic height constraints are fixed (Desktop/Tablet)
                    if (widget.isExpanded) const Spacer() else const SizedBox(height: s32),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isPopular ? accentColor : kWhite,
                          foregroundColor: widget.isPopular ? kWhite : accentColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: s20),
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(s12)),
                        ),
                        child: Text(
                          context.localization.subscription_section_get_started,
                          style: GoogleFonts.inter(fontSize: tx16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate(target: _isHovered ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), curve: Curves.easeOutCubic),
    );
  }
}
