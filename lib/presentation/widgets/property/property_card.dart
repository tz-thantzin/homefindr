import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/extensions/theme_ex.dart';

class PropertyCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String status;
  final int beds;
  final int baths;
  final int sqft;
  final bool isFeatured;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.status,
    required this.beds,
    required this.baths,
    required this.sqft,
    this.isFeatured = false,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? Matrix4.translationValues(0, -8, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(s4),
          border: Border.all(
            color: _isHovered ? kPrimary.withValues(alpha: 0.5) : kBorderDark,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? kPrimary.withValues(alpha: 0.12)
                  : kBlack.withValues(alpha: 0.3),
              blurRadius: _isHovered ? 32 : 16,
              offset: Offset(0, _isHovered ? 16 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(s4)),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: kCanvas,
                      height: 240,
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: kBorderDark,
                            borderRadius: BorderRadius.circular(s4),
                          ),
                          child: const Icon(Icons.home_outlined, color: kMuted, size: 24),
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: kCanvas,
                      height: 240,
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined, size: 40, color: kBorderDark),
                      ),
                    ),
                  ),
                ),

                // Dark scrim on image for readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          kBlack.withValues(alpha: 0.55),
                          kTransparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Status badge
                Positioned(
                  top: s12,
                  left: s12,
                  child: Row(
                    children: [
                      _StatusBadge(status: widget.status),
                      if (widget.isFeatured) ...[
                        const SizedBox(width: s6),
                        _FeaturedBadge(),
                      ],
                    ],
                  ),
                ),

                // Favorite button
                Positioned(
                  top: s10,
                  right: s10,
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.all(s8),
                    decoration: BoxDecoration(
                      color: kBlack.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(s4),
                      border: Border.all(color: kWhite.withValues(alpha: 0.1)),
                    ),
                    child: const Icon(Icons.favorite_border, size: s16, color: kCream),
                  ),
                ),
              ],
            ),

            // ── Details ──
            Padding(
              padding: const EdgeInsets.all(s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: tx18,
                      fontWeight: semiBold,
                      color: kCream,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: s8),

                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: s14, color: kPrimary.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(color: kMuted, fontSize: tx13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: s16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _StatChip(icon: Icons.king_bed_outlined, value: '${widget.beds}', label: context.localization.property_detail_beds),
                      const SizedBox(width: s16),
                      _StatChip(icon: Icons.bathtub_outlined, value: '${widget.baths}', label: context.localization.property_detail_baths),
                      const SizedBox(width: s16),
                      _StatChip(icon: Icons.square_foot, value: '${widget.sqft}', label: 'sqft'),
                    ],
                  ),

                  const SizedBox(height: s16),
                  Container(height: 1, color: kDividerDark),
                  const SizedBox(height: s16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.price,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: tx20,
                              fontWeight: bold,
                              color: kPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(s8),
                        decoration: BoxDecoration(
                          color: kCanvas,
                          borderRadius: BorderRadius.circular(s4),
                          border: Border.all(color: kBorderDark),
                        ),
                        child: const Icon(Icons.share_outlined, size: s16, color: kMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, text) = switch (status) {
      'For Sale' => (kPrimary, _localizedStatus(context, status)),
      'For Rent' => (kBadgeRent, _localizedStatus(context, status)),
      'Sold'     => (kBadgeSold, _localizedStatus(context, status)),
      _          => (kBorderDark, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s10, vertical: s5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(s2),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          color: kCream,
          fontSize: tx11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s8, vertical: s5),
      decoration: BoxDecoration(
        color: kBlack.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(s2),
        border: Border.all(color: kPrimary.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 10, color: kPrimary),
          const SizedBox(width: 4),
          Text(
            context.localization.property_card_featured,
            style: GoogleFonts.dmSans(color: kPrimary, fontSize: tx11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: s14, color: kMuted),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: GoogleFonts.dmSans(fontSize: tx13, color: kMuted),
        ),
      ],
    );
  }
}

String _localizedStatus(BuildContext context, String status) => switch (status) {
  'For Sale' => context.localization.search_tab_for_sale,
  'For Rent' => context.localization.search_tab_for_rent,
  'Sold'     => context.localization.search_filter_sold,
  _          => status,
};
