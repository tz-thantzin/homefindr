import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/constants/constant_colors.dart';
import '../../../../core/constants/constant_sizes.dart';
import '../../../../core/extensions/context_ex.dart';
import '../../../../core/router/app_router.dart';
import '../../../../domain/models/property.dart';
import '../../view_models/property_view_model.dart';
import '../../widgets/common/animated_slide_button.dart';
import '../../widgets/common/nav_logo.dart';
import '../../widgets/footer/footer_section.dart';
import '../../widgets/hero/desktop_nav_bar.dart';
import '../../widgets/hero/mobile_drawer.dart';
import '../../widgets/property/property_card.dart';

// ─────────────────────────────────────────────
// Property Detail Screen
// ─────────────────────────────────────────────
class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesViewModel);

    return propertiesAsync.when(
      loading: () => const _DetailLoadingScreen(),
      error: (e, _) => _DetailErrorScreen(error: e.toString()),
      data: (properties) {
        final property = properties.firstWhere((p) => p.id == propertyId, orElse: () => properties.first);
        final similar = properties.where((p) => p.type == property.type && p.id != property.id).take(3).toList();

        return _DetailContent(property: property, similar: similar);
      },
    );
  }
}

// ─────────────────────────────────────────────
// Main Detail Content
// ─────────────────────────────────────────────
class _DetailContent extends StatefulWidget {
  final Property property;
  final List<Property> similar;

  const _DetailContent({required this.property, required this.similar});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  int _selectedImage = 0;
  bool _isFavorited = false;

  // Simulated gallery — in real app these come from property.images
  List<String> get _gallery => [
    widget.property.imageUrl,
    'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600570997533-f14d7a120083?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600607687940-4e5a99427ae5?auto=format&fit=crop&w=1200&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: context.isDesktop ? null : const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ScreenTypeLayout.builder(
          desktop: (_) => const DesktopNavBar(),
          mobile: (_) => const _MobileScrollNavBar(),
        ),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image Gallery ──
            _HeroGallery(
              gallery: _gallery,
              selectedIndex: _selectedImage,
              onSelect: (i) => setState(() => _selectedImage = i),
              property: widget.property,
              isFavorited: _isFavorited,
              onFavorite: () => setState(() => _isFavorited = !_isFavorited),
            ),

            // ── Body ──
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.isDesktop ? s40 : s20, vertical: s40),
                  child: ScreenTypeLayout.builder(
                    desktop: (_) => _buildDesktopBody(context),
                    mobile: (_) => _buildMobileBody(context),
                  ),
                ),
              ),
            ),

            // ── Similar Properties ──
            if (widget.similar.isNotEmpty) _SimilarSection(similar: widget.similar),

            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopBody(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _DetailsColumn(property: widget.property)),
        const SizedBox(width: s40),
        SizedBox(width: 340, child: _ContactAgentCard(property: widget.property)),
      ],
    );
  }

  Widget _buildMobileBody(BuildContext context) {
    return Column(
      children: [
        _DetailsColumn(property: widget.property),
        const SizedBox(height: s32),
        _ContactAgentCard(property: widget.property),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Hero Gallery with crossfade + thumbnails
// ─────────────────────────────────────────────
class _HeroGallery extends StatelessWidget {
  final List<String> gallery;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Property property;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _HeroGallery({
    required this.gallery,
    required this.selectedIndex,
    required this.onSelect,
    required this.property,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return SizedBox(
      height: isMobile ? 280 : 520,
      child: Stack(
        children: [
          // Main image with Hero widget for shared element transition
          Positioned.fill(
            child: Hero(
              tag: 'property_image_${property.id}',
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: CachedNetworkImage(
                  key: ValueKey(selectedIndex),
                  imageUrl: gallery[selectedIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, _) => Container(color: kGrey200),
                ),
              ),
            ),
          ),

          // Dark gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kTransparent, kBlack.withValues(alpha: 0.65)],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 110,
            left: s20,
            child: _CircleIconBtn(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.3),
          ),

          // Favorite + Share buttons
          Positioned(
            top: 110,
            right: s20,
            child: Row(
              children: [
                _CircleIconBtn(
                  icon: Icons.share_outlined,
                  onTap: () {},
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                const SizedBox(width: s10),
                _CircleIconBtn(
                  icon: isFavorited ? Icons.favorite : Icons.favorite_border,
                  iconColor: isFavorited ? Colors.red : null,
                  onTap: onFavorite,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              ],
            ),
          ),

          // Price + status bottom left
          Positioned(
            bottom: s20,
            left: s20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadge(status: property.status),
                const SizedBox(height: s8),
                Text(
                  property.price,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: tx32,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
              ],
            ),
          ),

          // Thumbnail strip bottom right
          if (!isMobile)
            Positioned(
              bottom: s16,
              right: s20,
              child: _ThumbnailStrip(gallery: gallery, selectedIndex: selectedIndex, onSelect: onSelect),
            ),
        ],
      ),
    );
  }
}

class _ThumbnailStrip extends StatelessWidget {
  final List<String> gallery;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ThumbnailStrip({required this.gallery, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: gallery.asMap().entries.map((e) {
        final isSelected = e.key == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: s8),
            width: isSelected ? 72 : 60,
            height: isSelected ? 52 : 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(s8),
              border: Border.all(color: isSelected ? kPrimary : kTransparent, width: 2.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(s6),
              child: ColorFiltered(
                colorFilter: isSelected
                    ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                    : const ColorFilter.mode(Colors.black45, BlendMode.darken),
                child: CachedNetworkImage(imageUrl: e.value, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Details Column (left side)
// ─────────────────────────────────────────────
class _DetailsColumn extends StatelessWidget {
  final Property property;

  const _DetailsColumn({required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        Row(
          children: [
            GestureDetector(
              onTap: () => context.goNamed(RouteName.home),
              child: Text(
                context.localization.contact_breadcrumb_home,
                style: TextStyle(color: kPrimary, fontSize: tx14, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, size: s16, color: kGrey400),
            Text(
              _typeLabel(context, property.type),
              style: TextStyle(color: kGrey500, fontSize: tx14),
            ),
            Icon(Icons.chevron_right, size: s16, color: kGrey400),
            Expanded(
              child: Text(
                property.title,
                style: TextStyle(color: kGrey700, fontSize: tx14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: s20),

        // Title
        Text(
          property.title,
          style: const TextStyle(fontSize: tx32, fontWeight: FontWeight.w800, color: kSecondary, height: 1.2),
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.2),

        const SizedBox(height: s12),

        // Location
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: kPrimary, size: s18),
            const SizedBox(width: s6),
            Text(
              property.location,
              style: const TextStyle(color: kGrey700, fontSize: tx16),
            ),
          ],
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

        const SizedBox(height: s24),

        // Stats row
        _StatsRow(property: property).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.15),

        const SizedBox(height: s32),
        const Divider(color: kGrey200),
        const SizedBox(height: s32),

        // About
        Text(
          context.localization.property_detail_about,
          style: TextStyle(fontSize: tx22, fontWeight: FontWeight.w700, color: kSecondary),
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: s16),

        Text(
          context.localization.property_detail_description_body(
            _typeLabel(context, property.type).toLowerCase(),
            property.location,
            property.beds,
            property.baths,
            property.sqft,
          ),
          style: const TextStyle(fontSize: tx16, color: kGrey800, height: 1.75),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

        const SizedBox(height: s32),
        const Divider(color: kGrey200),
        const SizedBox(height: s32),

        // Features
        Text(
          context.localization.property_detail_features_amenities,
          style: TextStyle(fontSize: tx22, fontWeight: FontWeight.w700, color: kSecondary),
        ).animate().fadeIn(delay: 350.ms),

        const SizedBox(height: s20),

        _FeaturesGrid().animate().fadeIn(delay: 400.ms, duration: 500.ms),

        const SizedBox(height: s32),
        const Divider(color: kGrey200),
        const SizedBox(height: s32),

        // Map placeholder
        Text(
          context.localization.property_detail_location,
          style: TextStyle(fontSize: tx22, fontWeight: FontWeight.w700, color: kSecondary),
        ).animate().fadeIn(delay: 450.ms),

        const SizedBox(height: s16),

        _MapPlaceholder(location: property.location).animate().fadeIn(delay: 500.ms, duration: 600.ms),

        const SizedBox(height: s40),
      ],
    );
  }

  String _typeLabel(BuildContext context, PropertyType type) {
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
}

class _StatsRow extends StatelessWidget {
  final Property property;

  const _StatsRow({required this.property});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: s16,
      runSpacing: s12,
      children: [
        _StatChip(
          icon: Icons.king_bed_outlined,
          label: '${property.beds} ${context.localization.property_detail_beds}',
        ),
        _StatChip(
          icon: Icons.bathtub_outlined,
          label: '${property.baths} ${context.localization.property_detail_baths}',
        ),
        _StatChip(icon: Icons.square_foot, label: '${property.sqft} ${context.localization.property_detail_sqft}'),
        _StatChip(
          icon: Icons.category_outlined,
          label: property.type.name[0].toUpperCase() + property.type.name.substring(1),
        ),
        _StatChip(icon: Icons.sell_outlined, label: property.status, highlight: true),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _StatChip({required this.icon, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s10),
      decoration: BoxDecoration(
        color: highlight ? kPrimary.withValues(alpha: 0.08) : kGrey100,
        borderRadius: BorderRadius.circular(s8),
        border: Border.all(color: highlight ? kPrimary.withValues(alpha: 0.3) : kGrey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: s16, color: highlight ? kPrimary : kGrey700),
          const SizedBox(width: s8),
          Text(
            label,
            style: TextStyle(fontSize: tx14, fontWeight: FontWeight.w600, color: highlight ? kPrimary : kSecondary),
          ),
        ],
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.ac_unit, 'label': context.localization.property_detail_feature_ac},
      {'icon': Icons.local_parking, 'label': context.localization.property_detail_feature_parking},
      {'icon': Icons.pool, 'label': context.localization.property_detail_feature_pool},
      {'icon': Icons.security, 'label': context.localization.property_detail_feature_security},
      {'icon': Icons.fitness_center, 'label': context.localization.property_detail_feature_gym},
      {'icon': Icons.wifi, 'label': context.localization.property_detail_feature_wifi},
      {'icon': Icons.elevator, 'label': context.localization.property_detail_feature_elevator},
      {'icon': Icons.balcony, 'label': context.localization.property_detail_feature_balcony},
      {'icon': Icons.local_laundry_service, 'label': context.localization.property_detail_feature_laundry},
      {'icon': Icons.pets, 'label': context.localization.property_detail_feature_pets},
    ];
    return Wrap(
      spacing: s12,
      runSpacing: s12,
      children: features.asMap().entries.map((e) {
        return Container(
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: s14, vertical: s10),
              decoration: BoxDecoration(
                border: Border.all(color: kGrey200),
                borderRadius: BorderRadius.circular(s8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e.value['icon'] as IconData, size: s16, color: kPrimary),
                  const SizedBox(width: s8),
                  Flexible(
                    child: Text(
                      e.value['label'] as String,
                      style: const TextStyle(fontSize: tx12, fontWeight: FontWeight.w500, color: kGrey800),
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: e.key * 50),
              duration: 350.ms,
            )
            .scale(begin: const Offset(0.92, 0.92));
      }).toList(),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final String location;

  const _MapPlaceholder({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kGrey100,
        borderRadius: BorderRadius.circular(s16),
        border: Border.all(color: kGrey200),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Grid lines to simulate a map
          CustomPaint(painter: _MapGridPainter(), child: const SizedBox.expand()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(s14),
                decoration: BoxDecoration(
                  color: kPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4)],
                ),
                child: const Icon(Icons.location_on, color: kWhite, size: s28),
              ),
              const SizedBox(height: s12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s8),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(s20),
                  boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.1), blurRadius: 10)],
                ),
                child: Text(
                  location,
                  style: const TextStyle(fontSize: tx14, fontWeight: FontWeight.w600, color: kSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kGrey300.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some fake roads
    final roadPaint = Paint()
      ..color = kWhite
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width * 0.6, size.height * 0.75), roadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
// Contact Agent Card (right sidebar)
// ─────────────────────────────────────────────
class _ContactAgentCard extends StatefulWidget {
  final Property property;

  const _ContactAgentCard({required this.property});

  @override
  State<_ContactAgentCard> createState() => _ContactAgentCardState();
}

class _ContactAgentCardState extends State<_ContactAgentCard> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(s28),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s16),
        border: Border.all(color: kGrey200),
        boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Agent info
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: kPrimary.withValues(alpha: 0.12),
                child: const Icon(Icons.person, color: kPrimary, size: s28),
              ),
              const SizedBox(width: s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.property_detail_agent_name,
                      style: TextStyle(fontSize: tx16, fontWeight: FontWeight.w700, color: kSecondary),
                    ),
                    Text(
                      context.localization.property_detail_agent_title,
                      style: TextStyle(fontSize: tx12, color: kGrey500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: s8, vertical: s4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(s20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.localization.property_detail_agent_online,
                      style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: s20),
          const Divider(color: kGrey200),
          const SizedBox(height: s20),

          Text(
            context.localization.property_detail_send_message,
            style: TextStyle(fontSize: tx18, fontWeight: FontWeight.w700, color: kSecondary),
          ),
          const SizedBox(height: s4),
          Text(
            context.localization.property_detail_interested_in(widget.property.title),
            style: TextStyle(fontSize: tx12, color: kGrey500),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: s20),

          _InputField(
            controller: _nameCtrl,
            hint: context.localization.property_detail_hint_name,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: s12),
          _InputField(
            controller: _emailCtrl,
            hint: context.localization.property_detail_hint_email,
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: s12),
          _InputField(
            controller: _msgCtrl,
            hint: context.localization.property_detail_hint_message,
            icon: Icons.message_outlined,
            maxLines: 4,
          ),

          const SizedBox(height: s20),

          // Send message button
          SizedBox(
            width: double.infinity,
            child: AnimatedSlideButton(
              title: context.localization.property_detail_send_btn,
              width: double.infinity,
              height: s50,
              icon: Icons.send,
              buttonColor: kPrimary,
              borderColor: kPrimary,
              onHoverColor: kSecondary,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: s12),

          // Call button
          SizedBox(
            width: double.infinity,
            height: s48,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kGrey300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              icon: const Icon(Icons.phone_outlined, size: s16, color: kSecondary),
              label: Text(
                context.localization.property_detail_call_agent,
                style: TextStyle(color: kSecondary, fontWeight: FontWeight.w600, fontSize: tx14),
              ),
            ),
          ),

          const SizedBox(height: s20),
          const Divider(color: kGrey200),
          const SizedBox(height: s16),

          // Price breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Listed Price',
                style: TextStyle(fontSize: tx14, color: kGrey700),
              ),
              Text(
                widget.property.price,
                style: const TextStyle(fontSize: tx18, fontWeight: FontWeight.w800, color: kPrimary),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _InputField({required this.controller, required this.hint, required this.icon, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGrey100,
        borderRadius: BorderRadius.circular(s8),
        border: Border.all(color: kGrey200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kGrey500, fontSize: tx14),
          prefixIcon: maxLines == 1 ? Icon(icon, size: s16, color: kGrey500) : null,
          contentPadding: EdgeInsets.symmetric(horizontal: maxLines > 1 ? s16 : 0, vertical: s14),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: tx14, color: kSecondary),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Similar Properties Section
// ─────────────────────────────────────────────
class _SimilarSection extends StatelessWidget {
  final List<Property> similar;

  const _SimilarSection({required this.similar});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kGrey100,
      padding: const EdgeInsets.symmetric(vertical: s60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.property_detail_similar,
                  style: TextStyle(fontSize: tx28, fontWeight: FontWeight.w800, color: kSecondary),
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: s32),
                ScreenTypeLayout.builder(desktop: (_) => _buildRow(context), mobile: (_) => _buildColumn(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context) {
    return Row(
      children: similar.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: e.key == 0 ? 0 : s16),
            child: GestureDetector(
              onTap: () => context.goNamed(RouteName.propertyDetail, pathParameters: {'id': e.value.id}),
              child:
                  PropertyCard(
                        imageUrl: e.value.imageUrl,
                        title: e.value.title,
                        location: e.value.location,
                        price: e.value.price,
                        status: e.value.status,
                        beds: e.value.beds,
                        baths: e.value.baths,
                        sqft: e.value.sqft,
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: e.key * 150),
                        duration: 600.ms,
                      )
                      .slideY(begin: 0.2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColumn(BuildContext context) {
    return Column(
      children: similar.asMap().entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: s16),
          child: GestureDetector(
            onTap: () => context.goNamed(RouteName.propertyDetail, pathParameters: {'id': e.value.id}),
            child:
                PropertyCard(
                  imageUrl: e.value.imageUrl,
                  title: e.value.title,
                  location: e.value.location,
                  price: e.value.price,
                  status: e.value.status,
                  beds: e.value.beds,
                  baths: e.value.baths,
                  sqft: e.value.sqft,
                ).animate().fadeIn(
                  delay: Duration(milliseconds: e.key * 150),
                  duration: 600.ms,
                ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'For Rent'
        ? kSecondary
        : status == 'Sold'
        ? kGrey700
        : kPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(s4)),
      child: Text(
        status,
        style: const TextStyle(color: kWhite, fontSize: tx12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleIconBtn({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kWhite.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.15), blurRadius: 10)],
        ),
        child: Icon(icon, size: s18, color: iconColor ?? kSecondary),
      ),
    );
  }
}

class _DetailLoadingScreen extends StatelessWidget {
  const _DetailLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: kPrimary),
            const SizedBox(height: s16),
            Text(
              context.localization.property_detail_loading,
              style: TextStyle(color: kGrey500, fontSize: tx14),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailErrorScreen extends StatelessWidget {
  final String error;

  const _DetailErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(error)));
  }
}

// Reuse mobile scroll nav from home
class _MobileScrollNavBar extends StatefulWidget {
  const _MobileScrollNavBar();

  @override
  State<_MobileScrollNavBar> createState() => _MobileScrollNavBarState();
}

class _MobileScrollNavBarState extends State<_MobileScrollNavBar> {
  bool _isScrolled = false;

  void _onScroll() {
    final scrolled = PrimaryScrollController.of(context).offset > 50;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(_onScroll);
  }

  @override
  void dispose() {
    PrimaryScrollController.of(context).removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _isScrolled ? kSecondary.withValues(alpha: 0.97) : kBlack.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NavLogo(),
          IconButton(
            icon: const Icon(Icons.menu, color: kWhite, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),
    );
  }
}
