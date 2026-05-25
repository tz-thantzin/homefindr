import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';

class CategoryCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final String count;
  final String suffix;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.count,
    required this.suffix,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(s4),
          border: Border.all(
            color: isHovered ? kPrimary.withValues(alpha: 0.6) : kBorderDark,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(color: kPrimary.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8)),
                  BoxShadow(color: kBlack.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                ]
              : [
                  BoxShadow(color: kBlack.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2)),
                ],
        ),
        padding: const EdgeInsets.all(s28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: s56,
              height: s56,
              decoration: BoxDecoration(
                color: isHovered ? kPrimary.withValues(alpha: 0.15) : kCanvas,
                borderRadius: BorderRadius.circular(s8),
                border: Border.all(
                  color: isHovered ? kPrimary.withValues(alpha: 0.4) : kBorderDark,
                ),
              ),
              child: Icon(
                widget.icon,
                size: s28,
                color: isHovered ? kPrimary : kMuted,
              ),
            ),

            const SizedBox(height: s16),

            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: tx16,
                fontWeight: FontWeight.w600,
                color: isHovered ? kCream : kCream.withValues(alpha: 0.85),
              ),
            ),

            const SizedBox(height: s6),

            Text(
              "${widget.count} ${widget.suffix}",
              style: GoogleFonts.dmSans(
                fontSize: tx13,
                color: isHovered ? kPrimary.withValues(alpha: 0.8) : kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

