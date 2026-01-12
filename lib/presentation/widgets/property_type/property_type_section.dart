import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      color: kWhite,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              children: [
                Text(
                  context.localization.property_type_section_title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: tx42, fontWeight: FontWeight.bold, color: kSecondary, height: 1.2),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: s12),
                Text(
                      context.localization.property_type_section_subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: tx18, color: kGrey500),
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
              if (info.visibleFraction >= 0.45 && !_startAnimation) {
                setState(() {
                  _startAnimation = true;
                });
              }
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: propertiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(err.toString()),
                data: (properties) {
                  final categories = _buildCategories(properties);

                  return ScreenTypeLayout.builder(
                    desktop: (_) => _buildGrid(context, 5, categories, _startAnimation),
                    tablet: (_) => _buildGrid(context, 3, categories, _startAnimation),
                    mobile: (_) => _buildGrid(context, 2, categories, _startAnimation),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build category data from fetched properties
  List<Map<String, dynamic>> _buildCategories(List properties) {
    return PropertyType.values.map((type) {
      final count = properties.where((p) => p.type == type).length;

      return {'type': type, 'icon': _getIconForType(type), 'count': count.toString().padLeft(2, '0')};
    }).toList();
  }

  IconData _getIconForType(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return Icons.apartment;
      case PropertyType.villa:
        return Icons.villa;
      case PropertyType.studio:
        return Icons.home_work;
      case PropertyType.office:
        return Icons.business_center;
      case PropertyType.townhouse:
        return Icons.home;
    }
  }

  String _getLocalizedTypeName(BuildContext context, PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return context.localization.property_type_section_apartment;
      case PropertyType.villa:
        return context.localization.property_type_section_villa;
      case PropertyType.studio:
        return context.localization.property_type_section_studio;
      case PropertyType.office:
        return context.localization.property_type_section_office;
      case PropertyType.townhouse:
        return context.localization.property_type_section_townhouse;
    }
  }

  Widget _buildGrid(
    BuildContext context,
    int crossAxisCount,
    List<Map<String, dynamic>> categories,
    bool startAnimation,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: s20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: s24,
        mainAxisSpacing: s24,
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

        if (!startAnimation) {
          return Opacity(opacity: 0, child: card);
        }

        return card
            .animate()
            .fadeIn(delay: (index * 200).ms, duration: 700.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1))
            .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}
