import 'package:flutter/material.dart';
import 'package:homefindr/presentation/widgets/property_type/property_type_card.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:homefindr/core/extensions/context_ex.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../domain/models/property.dart';
import '../../../core/constants/constant_data.dart';

class PropertyTypeSection extends StatefulWidget {
  const PropertyTypeSection({super.key});

  @override
  State<PropertyTypeSection> createState() => _PropertyTypeSectionState();
}

class _PropertyTypeSectionState extends State<PropertyTypeSection> {
  bool _startAnimation = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories =
    PropertyType.values.map((type) {
      final count = mockProperties.where((p) => p.type == type).length;
      return {
        'type': type,
        'icon': _getIconForType(type),
        'count': count.toString().padLeft(2, '0'),
      };
    }).toList();

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
                  style: const TextStyle(
                    fontSize: tx42,
                    fontWeight: FontWeight.bold,
                    color: kSecondary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: s12),
                Text(
                  context.localization.property_type_section_subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: tx18,
                    color: kGrey500,
                  ),
                ),
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
              child: ScreenTypeLayout.builder(
                desktop: (context) =>
                    _buildGrid(context, 5, categories, _startAnimation),
                tablet: (context) =>
                    _buildGrid(context, 3, categories, _startAnimation),
                mobile: (context) =>
                    _buildGrid(context, 2, categories, _startAnimation),
              ),
            ),
          ),
        ],
      ),
    );
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
          suffix: context
              .localization.property_type_section_properties_suffix,
        );

        if (!startAnimation) {
          return Opacity(opacity: 0, child: card);
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 120)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.9 + (0.1 * value),
                child: child,
              ),
            );
          },
          child: card,
        );
      },
    );
  }
}

