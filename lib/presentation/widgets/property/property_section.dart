import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homefindr/core/extensions/context_ex.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/widgets/animated_slide_button.dart';
import '../../view_models/property_view_model.dart';
import 'property_card.dart';

class PropertySection extends ConsumerStatefulWidget {
  const PropertySection({super.key});

  @override
  ConsumerState<PropertySection> createState() => _PropertySectionState();
}

class _PropertySectionState extends ConsumerState<PropertySection> {
  bool _startAnimation = false;

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(latestPropertiesViewModel(6));

    return Container(
      width: double.infinity,
      color: kGrey100,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              children: [
                Text(
                  context.localization.property_discover_our_latest,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: tx42,
                    fontWeight: FontWeight.bold,
                    color: kSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: s12),
                Text(
                  context.localization.property_explore_newest_listing,
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
            key: const Key('property_grid'),
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
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(err.toString()),
                data: (properties) {
                  return ScreenTypeLayout.builder(
                    desktop: (_) =>
                        _buildGrid(context, properties, 3, _startAnimation),
                    tablet: (_) =>
                        _buildGrid(context, properties, 2, _startAnimation),
                    mobile: (_) =>
                        _buildGrid(context, properties, 1, _startAnimation),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: s60),

          AnimatedSlideButton(
            title: context.localization.property_view_all_properties_btn,
            width: s200,
            hasIcon: true,
            icon: Icons.north_east,
            onPressed: () {},
          )
              .animate(target: _startAnimation ? 1 : 0)
              .fadeIn(delay: 800.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context,
      List properties,
      int crossAxisCount,
      bool startAnimation,) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: s20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: s32,
        mainAxisSpacing: s32,
        mainAxisExtent: 450,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];

        final card = PropertyCard(
          imageUrl: property.imageUrl,
          title: property.title,
          location: property.location,
          price: property.price,
          status: property.status,
          beds: property.beds,
          baths: property.baths,
          sqft: property.sqft,
        );

        if (!startAnimation) {
          return Opacity(opacity: 0, child: card);
        }

        return card
            .animate()
            .fadeIn(delay: (index * 250).ms, duration: 800.ms)
            .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}
