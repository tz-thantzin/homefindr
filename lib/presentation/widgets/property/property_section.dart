import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/widgets/animated_slide_button.dart';
import '../../view_models/property_view_model.dart';
import 'property_card.dart';

class PropertySection extends ConsumerWidget {
  const PropertySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(latestPropertiesViewModel(6));

    return Container(
      width: double.infinity,
      color: kGrey100,
      padding: const EdgeInsets.symmetric(vertical: s80),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              children: const [
                Text(
                  "Discover Our Latest Properties",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tx42, fontWeight: FontWeight.bold, color: kSecondary),
                ),
                SizedBox(height: s12),
                Text(
                  "Explore the newest listings in your favorite neighborhoods.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tx18, color: kGrey500),
                ),
              ],
            ),
          ),

          const SizedBox(height: s60),

          // Grid
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: propertiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text(err.toString()),
              data: (properties) {
                return ScreenTypeLayout.builder(
                  desktop: (_) => _buildGrid(context, properties, 3),
                  tablet: (_) => _buildGrid(context, properties, 2),
                  mobile: (_) => _buildGrid(context, properties, 1),
                );
              },
            ),
          ),

          const SizedBox(height: s60),

          AnimatedSlideButton(
            title: "View All Properties",
            width: s200,
            hasIcon: true,
            icon: Icons.north_east,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List properties, int crossAxisCount) {
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

        return PropertyCard(
          imageUrl: property.imageUrl,
          title: property.title,
          location: property.location,
          price: property.price,
          status: property.status,
          beds: property.beds,
          baths: property.baths,
          sqft: property.sqft,
        );
      },
    );
  }
}
