import 'package:flutter/material.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';

class CategoryCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final String count;
  final String suffix;

  const CategoryCard({super.key, required this.name, required this.icon, required this.count, required this.suffix});

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isHovered ? kPrimary : kGrey100,
          borderRadius: BorderRadius.circular(s12),
          boxShadow: isHovered
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))]
              : [],
        ),
        padding: const EdgeInsets.all(s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(widget.icon, size: s48, color: isHovered ? kWhite : kSecondary),
            ),
            const SizedBox(height: s16),
            Text(
              widget.name,
              style: TextStyle(fontSize: tx18, fontWeight: FontWeight.bold, color: isHovered ? kWhite : kSecondary),
            ),
            const SizedBox(height: s8),
            Text(
              "${widget.count} ${widget.suffix}",
              style: TextStyle(fontSize: tx14, color: isHovered ? kWhite.withValues(alpha: 0.8) : kGrey500),
            ),
          ],
        ),
      ),
    );
  }
}
