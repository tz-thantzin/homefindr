import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../domain/models/property.dart';
import '../../view_models/property_view_model.dart';
import 'property_type_card.dart';

class PropertyTypeSection extends ConsumerStatefulWidget {
  const PropertyTypeSection({super.key});

  @override
  ConsumerState<PropertyTypeSection> createState() => _PropertyTypeSectionState();
}

class _PropertyTypeSectionState extends ConsumerState<PropertyTypeSection> {
  bool _startAnimation = false;

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesViewModel);

    return Container(
      width: double.infinity,
      color: kSecondary,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              children: [
                Text(
                  context.localization.property_type_section_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: tx42,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: kCream,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

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
                  context.localization.property_type_section_subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(fontSize: tx16, color: kMuted),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ),

          const SizedBox(height: s60),

          VisibilityDetector(
            key: const Key('property_type_grid'),
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
                data: (properties) {
                  final categories = _buildCategories(properties);
                  return ScreenTypeLayout.builder(
                    desktop: (_) => _buildGrid(context, 5, categories),
                    tablet: (_) => _buildGrid(context, 3, categories),
                    mobile: (_) => _buildGrid(context, 2, categories),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _buildCategories(List properties) {
    return PropertyType.values.map((type) {
      final count = properties.where((p) => p.type == type).length;
      return {'type': type, 'icon': _getIconForType(type), 'count': count.toString().padLeft(2, '0')};
    }).toList();
  }

  IconData _getIconForType(PropertyType type) {
    return switch (type) {
      PropertyType.apartment => Icons.apartment,
      PropertyType.villa => Icons.villa,
      PropertyType.studio => Icons.home_work,
      PropertyType.office => Icons.business_center,
      PropertyType.townhouse => Icons.home,
    };
  }

  String _getLocalizedTypeName(BuildContext context, PropertyType type) {
    return switch (type) {
      PropertyType.apartment => context.localization.property_type_section_apartment,
      PropertyType.villa => context.localization.property_type_section_villa,
      PropertyType.studio => context.localization.property_type_section_studio,
      PropertyType.office => context.localization.property_type_section_office,
      PropertyType.townhouse => context.localization.property_type_section_townhouse,
    };
  }

  Widget _buildGrid(BuildContext context, int crossAxisCount, List<Map<String, dynamic>> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: s20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: s20,
        mainAxisSpacing: s20,
        mainAxisExtent: 200,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        final type = item['type'] as PropertyType;

        final card = CategoryCard(
          name: _getLocalizedTypeName(context, type),
          icon: item['icon'] as IconData,
          count: item['count'] as String,
          suffix: context.localization.property_type_section_properties_suffix,
        );

        if (!_startAnimation) return Opacity(opacity: 0, child: card);

        return card
            .animate()
            .fadeIn(delay: (index * 120).ms, duration: 600.ms)
            .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1))
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

