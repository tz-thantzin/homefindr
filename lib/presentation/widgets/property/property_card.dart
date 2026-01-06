import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';

class PropertyCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String status;
  final int beds;
  final int baths;
  final int sqft;

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
            ? Matrix4.translationValues(0.0, -10.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(s12),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? kPrimary.withValues(alpha: 0.15)
                  : kBlack.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 30 : 20,
              offset: Offset(0, _isHovered ? 15 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(s12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: kGrey100),
                  ),
                ),
                // Badges
                Positioned(
                  top: s16,
                  left: s16,
                  child: Row(
                    children: [
                      _buildBadge(widget.status, widget.status == "For Rent" ? kSecondary : kPrimary)
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.easeOutBack),
                      const SizedBox(width: s8),
                      _buildBadge("Featured", kBlue)
                          .animate()
                          .scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
                    ],
                  ),
                ),
                Positioned(
                  bottom: s16,
                  right: s16,
                  child: Container(
                    padding: const EdgeInsets.all(s8),
                    decoration: const BoxDecoration(
                      color: kWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: s20),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: tx18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: s8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: s16, color: kGrey500),
                      const SizedBox(width: s4),
                      Expanded(
                        child: Text(
                          widget.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: kGrey500, fontSize: tx14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconDetail(Icons.king_bed_outlined, "${widget.beds} Beds"),
                      _iconDetail(Icons.bathtub_outlined, "${widget.baths} Baths"),
                      _iconDetail(Icons.square_foot, "${widget.sqft} sqft"),
                    ],
                  ),
                  const Divider(height: s32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: tx20,
                          fontWeight: FontWeight.bold,
                          color: kPrimary,
                        ),
                      ),
                      const Icon(Icons.share_outlined, size: s20, color: kGrey500),
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

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(s4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: kWhite, fontSize: tx12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _iconDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: s18, color: kGrey500),
        const SizedBox(width: s4),
        Text(text, style: const TextStyle(fontSize: tx14, color: kGrey500)),
      ],
    );
  }
}