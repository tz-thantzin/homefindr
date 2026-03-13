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
import '../../widgets/common/web_image.dart';
import '../../widgets/footer/footer_section.dart';
import '../../widgets/hero/desktop_nav_bar.dart';
import '../../widgets/hero/mobile_drawer.dart';
import '../../widgets/hero/mobile_nav_bar.dart';
import '../../widgets/property/property_card.dart';

class PropertyListingScreen extends ConsumerStatefulWidget {
  final String status;
  final String heroImage;
  final String heroTitle;
  final String heroSubtitle;
  final Color accentColor;
  final String initialType;

  const PropertyListingScreen({
    super.key,
    required this.status,
    required this.heroImage,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.accentColor,
    this.initialType = '',
  });

  @override
  ConsumerState<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends ConsumerState<PropertyListingScreen> {
  late String _activeType;
  int _minBeds = 0;
  String _sortBy = 'newest';
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _activeType = widget.initialType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  Widget _buildShimmer(BuildContext context) {
    final cols = _getGridCols(context);
    final hPad = _getHPad(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ListingHero(
            imageUrl: widget.heroImage,
            title: widget.heroTitle,
            subtitle: widget.heroSubtitle,
            status: widget.status,
            accentColor: widget.accentColor,
          ),
        ),
        SliverToBoxAdapter(
          child: ColoredBox(
            color: kGrey100,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, s40, hPad, s40),
                  child: PropertyGridShimmer(cols: cols),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getGridCols(BuildContext context) => context.isDesktop ? 3 : context.isTablet ? 2 : 1;
  double _getHPad(BuildContext context) => context.isDesktop ? s40 : s16;

  List<Property> _filterAndSort(List<Property> all) {
    var result = all.where((p) {
      final matchStatus = p.status == widget.status;
      final matchType = _activeType.isEmpty || p.type.name.toLowerCase() == _activeType;
      final matchBeds = _minBeds == 0 || p.beds >= _minBeds;
      return matchStatus && matchType && matchBeds;
    }).toList();

    switch (_sortBy) {
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesViewModel);

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: context.isDesktop ? null : const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ScreenTypeLayout.builder(
          desktop: (_) => const DesktopNavBar(),
          mobile: (_) => const MobileNavBar(),
        ),
      ),
      body: !_ready
          ? _buildShimmer(context)
          : propertiesAsync.when(
        loading: () => _buildShimmer(context),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (properties) {
          final filtered = _filterAndSort(properties);
          final cols = _getGridCols(context);
          final hPad = _getHPad(context);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListingHero(
                  imageUrl: widget.heroImage,
                  title: widget.heroTitle,
                  subtitle: widget.heroSubtitle,
                  status: widget.status,
                  accentColor: widget.accentColor,
                ),
              ),
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: kGrey100,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, s40, hPad, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FilterBar(
                              activeType: _activeType,
                              minBeds: _minBeds,
                              sortBy: _sortBy,
                              accentColor: widget.accentColor,
                              onTypeChanged: (v) => setState(() => _activeType = v),
                              onBedsChanged: (v) => setState(() => _minBeds = v),
                              onSortChanged: (v) => setState(() => _sortBy = v),
                            ),
                            const SizedBox(height: s24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${filtered.length} properties',
                                  style: const TextStyle(
                                    fontSize: tx16,
                                    fontWeight: FontWeight.w700,
                                    color: kSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.goNamed(
                                        RouteName.search,
                                        queryParameters: {'status': widget.status},
                                      ),
                                  child: Text(
                                    context.localization.search_advanced,
                                    style: TextStyle(
                                      fontSize: tx14,
                                      color: widget.accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: s24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: kGrey100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: s80),
                        child: Column(
                          children: [
                            const Icon(Icons.home_outlined, size: 64, color: kGrey300),
                            const SizedBox(height: s16),
                            Text(
                              context.localization.search_no_results_filters,
                              style: const TextStyle(fontSize: tx16, color: kGrey500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                DecoratedSliver(
                  decoration: const BoxDecoration(color: kGrey100),
                  sliver: SliverPadding(
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, s40),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) {
                          final p = filtered[i];
                          return GestureDetector(
                            onTap: () =>
                                context.goNamed(
                                  RouteName.propertyDetail,
                                  pathParameters: {'id': p.id},
                                ),
                            child: PropertyCard(
                              imageUrl: p.imageUrl,
                              title: p.title,
                              location: p.location,
                              price: p.price,
                              status: p.status,
                              beds: p.beds,
                              baths: p.baths,
                              sqft: p.sqft,
                            ),
                          );
                        },
                        childCount: filtered.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: s24,
                        mainAxisSpacing: s24,
                        mainAxisExtent: 450,
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: FooterSection()),
            ],
          );
        },
      ),
    );
  }
}

// Listing Hero Section
class ListingHero extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String status;
  final Color accentColor;

  const ListingHero({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.isMobile ? 300 : 420,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WebImage(url: imageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  kBlack.withValues(alpha: 0.75),
                  kBlack.withValues(alpha: 0.25),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.isDesktop ? s80 : s24,
              top: 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: s14, vertical: s6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(s20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: kWhite,
                      fontSize: tx12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                const SizedBox(height: s16),
                Text(
                  title,
                  style: TextStyle(
                    color: kWhite,
                    fontSize: context.isMobile ? tx32 : tx48,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: s12),
                SizedBox(
                  width: context.isMobile ? double.infinity : 480,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: kWhite.withValues(alpha: 0.8),
                      fontSize: tx16,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                ),
                const SizedBox(height: s24),
                Wrap(
                  spacing: s24,
                  runSpacing: s12,
                  children: [
                    HeroStat(
                      label: context.localization.listing_stat_properties_label,
                      value: context.localization.listing_stat_properties_value,
                    ),
                    HeroStat(
                      label: context.localization.listing_stat_cities_label,
                      value: context.localization.listing_stat_cities_value,
                    ),
                    HeroStat(
                      label: context.localization.listing_stat_clients_label,
                      value: context.localization.listing_stat_clients_value,
                    ),
                  ],
                ).animate().fadeIn(delay: 350.ms, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeroStat extends StatelessWidget {
  final String label;
  final String value;
  const HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: kWhite, fontSize: tx24, fontWeight: FontWeight.w800)),
        Text(label, style: TextStyle(color: kWhite.withValues(alpha: 0.65), fontSize: tx12)),
      ],
    );
  }
}

// Filter Bar
class FilterBar extends StatelessWidget {
  final String activeType;
  final int minBeds;
  final String sortBy;
  final Color accentColor;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<int> onBedsChanged;
  final ValueChanged<String> onSortChanged;

  const FilterBar({
    required this.activeType,
    required this.minBeds,
    required this.sortBy,
    required this.accentColor,
    required this.onTypeChanged,
    required this.onBedsChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(s20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s12),
        boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.search_filter_type,
            style: const TextStyle(
              fontSize: tx12,
              fontWeight: FontWeight.w700,
              color: kGrey500,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: s10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: context.localization.search_filter_all_types,
                  isActive: activeType.isEmpty,
                  color: accentColor,
                  onTap: () => onTypeChanged(''),
                ),
                ...PropertyType.values.map((type) {
                  final label =
                      '${type.name[0].toUpperCase()}${type.name.substring(1)}';
                  return FilterChipWidget(
                    label: label,
                    isActive: activeType == type.name,
                    color: accentColor,
                    onTap: () =>
                        onTypeChanged(activeType == type.name ? '' : type.name),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: s16),
          const Divider(color: kGrey200, height: 1),
          const SizedBox(height: s16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.search_filter_beds,
                      style: const TextStyle(
                        fontSize: tx12,
                        fontWeight: FontWeight.w700,
                        color: kGrey500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: s10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(4, (index) {
                          final labels = [
                            context.localization.search_filter_any,
                            '1+',
                            '2+',
                            '3+'
                          ];
                          return FilterChipWidget(
                            label: labels[index],
                            isActive: minBeds == index,
                            color: accentColor,
                            onTap: () => onBedsChanged(index),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: s20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localization.search_filter_sort,
                    style: const TextStyle(
                      fontSize: tx12,
                      fontWeight: FontWeight.w700,
                      color: kGrey500,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: s10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s8),
                    decoration: BoxDecoration(
                      border: Border.all(color: kGrey200),
                      borderRadius: BorderRadius.circular(s8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sortBy,
                        isDense: true,
                        style: const TextStyle(
                          fontSize: tx12,
                          color: kSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text(
                                context.localization.search_sort_newest_short),
                          ),
                          DropdownMenuItem(
                            value: 'price_low',
                            child: Text(
                                context.localization.search_sort_price_low_short),
                          ),
                          DropdownMenuItem(
                            value: 'price_high',
                            child: Text(
                                context.localization.search_sort_price_high_short),
                          ),
                        ],
                        onChanged: (v) => v != null ? onSortChanged(v) : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Filter Chip Widget
class FilterChipWidget extends StatefulWidget {
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;
  const FilterChipWidget({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isActive
        ? widget.color
        : (_hovered
        ? widget.color.withValues(alpha: 0.08)
        : kGrey100);
    final textColor = widget.isActive
        ? kWhite
        : (_hovered ? widget.color : kGrey700);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: s8),
          padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s8),
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(s20),
            border: Border.all(
              color: widget.isActive ? widget.color : kGrey300,
              width: widget.isActive ? 1.5 : 1,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: tx12,
              fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// Shimmer Grid for Loading State
class PropertyGridShimmer extends StatefulWidget {
  final int cols;
  const PropertyGridShimmer({required this.cols});

  @override
  State<PropertyGridShimmer> createState() => _PropertyGridShimmerState();
}

class _PropertyGridShimmerState extends State<PropertyGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: 140, radius: s12, anim: _anim),
        const SizedBox(height: s24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerBox(height: 16, width: 120, radius: 4, anim: _anim),
            ShimmerBox(height: 16, width: 80, radius: 4, anim: _anim),
          ],
        ),
        const SizedBox(height: s24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.cols,
            crossAxisSpacing: s24,
            mainAxisSpacing: s24,
            mainAxisExtent: 450,
          ),
          itemCount: widget.cols * 2,
          itemBuilder: (_, _) => PropertyCardSkeleton(anim: _anim),
        ),
      ],
    );
  }
}

// Skeleton Card for Property Loading
class PropertyCardSkeleton extends StatelessWidget {
  final Animation<double> anim;
  const PropertyCardSkeleton({required this.anim});

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(s12)),
            child: ShimmerBox(height: 240, radius: 0, anim: anim),
          ),
          Padding(
            padding: const EdgeInsets.all(s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 18, width: double.infinity, radius: 4, anim: anim),
                const SizedBox(height: s8),
                ShimmerBox(height: 14, width: 160, radius: 4, anim: anim),
                const SizedBox(height: s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                        (idx) => ShimmerBox(height: 14, width: 70, radius: 4, anim: anim),
                  ),
                ),
                const SizedBox(height: s16),
                const Divider(color: kGrey200, height: 1),
                const SizedBox(height: s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(height: 20, width: 100, radius: 4, anim: anim),
                    ShimmerBox(height: 20, width: 32, radius: 4, anim: anim),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Shimmer Box for animated gradients
class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  final Animation<double> anim;

  const ShimmerBox({
    required this.height,
    this.width,
    required this.radius,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, _) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + anim.value * 3, 0),
              end: Alignment(-0.5 + anim.value * 3, 0),
              colors: const [kGrey100, kGrey200, kGrey100],
            ),
          ),
        );
      },
    );
  }
}