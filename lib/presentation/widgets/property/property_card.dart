import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String status; // "For Rent" or "For Sale"
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s12),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                  imageUrl: imageUrl,
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
                    _buildBadge(status, status == "For Rent" ? kSecondary : kPrimary),
                    const SizedBox(width: s8),
                    _buildBadge("Featured", kBlue),
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
                  title,
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
                    Text(
                      location,
                      style: const TextStyle(color: kGrey500, fontSize: tx14),
                    ),
                  ],
                ),
                const SizedBox(height: s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconDetail(Icons.king_bed_outlined, "$beds Beds"),
                    _iconDetail(Icons.bathtub_outlined, "$baths Baths"),
                    _iconDetail(Icons.square_foot, "$sqft sqft"),
                  ],
                ),
                const Divider(height: s32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
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