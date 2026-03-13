import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../core/constants/constant_colors.dart';
import '../../../../../core/constants/constant_sizes.dart';
import '../../../../../core/extensions/context_ex.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../domain/models/property.dart';
import '../../../view_models/property_view_model.dart';
import '../../../widgets/hero/desktop_nav_bar.dart';
import '../../../widgets/hero/mobile_drawer.dart';
import '../../../widgets/property/property_card.dart';

// ─────────────────────────────────────────────
// Search Results Screen
// ─────────────────────────────────────────────
class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;
  final String status;
  final String type;

  const SearchResultsScreen({super.key, required this.query, required this.status, required this.type});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  // Active filters (initialized from URL params)
  late String _activeStatus;
  late String _activeType;
  late String _searchQuery;
  String _sortBy = 'newest';
  int _minBeds = 0;
  bool _showFilters = false; // For mobile filter drawer

  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeStatus = widget.status;
    _activeType = widget.type;
    _searchQuery = widget.query;
    _searchCtrl.text = widget.query;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Property> _applyFilters(List<Property> all) {
    var result = all.where((p) {
      final matchQuery =
          _searchQuery.isEmpty ||
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus = _activeStatus.isEmpty || p.status == _activeStatus;
      final matchType = _activeType.isEmpty || p.type.name.toLowerCase() == _activeType.toLowerCase();
      final matchBeds = _minBeds == 0 || p.beds >= _minBeds;
      return matchQuery && matchStatus && matchType && matchBeds;
    }).toList();

    switch (_sortBy) {
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
      default:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesViewModel);

    return Scaffold(
      drawer: context.isDesktop ? null : const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ScreenTypeLayout.builder(
          desktop: (_) => const DesktopNavBar(),
          mobile: (_) => _SearchTopBar(
            controller: _searchCtrl,
            onSearch: (q) => setState(() => _searchQuery = q),
            onFilterTap: () => setState(() => _showFilters = true),
          ),
        ),
      ),
      body: propertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimary)),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (properties) {
          final filtered = _applyFilters(properties);

          return ScreenTypeLayout.builder(
            desktop: (_) => _buildDesktopLayout(context, filtered),
            mobile: (_) => _buildMobileLayout(context, filtered),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<Property> filtered) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar filters
        Container(
          width: 280,
          height: context.screenHeight,
          color: kWhite,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(s24),
            child: _FilterPanel(
              activeStatus: _activeStatus,
              activeType: _activeType,
              sortBy: _sortBy,
              minBeds: _minBeds,
              onStatusChanged: (v) => setState(() => _activeStatus = v),
              onTypeChanged: (v) => setState(() => _activeType = v),
              onSortChanged: (v) => setState(() => _sortBy = v),
              onBedsChanged: (v) => setState(() => _minBeds = v),
              onReset: _resetFilters,
            ),
          ),
        ),

        // Results area
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            child: Padding(
              padding: const EdgeInsets.all(s32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchHeader(
                    query: _searchQuery,
                    count: filtered.length,
                    controller: _searchCtrl,
                    onSearch: (q) => setState(() => _searchQuery = q),
                  ),
                  const SizedBox(height: s24),
                  _ResultsGrid(properties: filtered, columns: 3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<Property> filtered) {
    return Stack(
      children: [
        SingleChildScrollView(
          primary: false,
          child: Padding(
            padding: const EdgeInsets.all(s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 110),
                _SearchHeader(
                  query: _searchQuery,
                  count: filtered.length,
                  controller: _searchCtrl,
                  onSearch: (q) => setState(() => _searchQuery = q),
                  compact: true,
                ),
                const SizedBox(height: s16),
                _ResultsGrid(properties: filtered, columns: 1),
              ],
            ),
          ),
        ),

        // Mobile filter bottom sheet overlay
        if (_showFilters)
          _MobileFilterSheet(
            activeStatus: _activeStatus,
            activeType: _activeType,
            sortBy: _sortBy,
            minBeds: _minBeds,
            onStatusChanged: (v) => setState(() => _activeStatus = v),
            onTypeChanged: (v) => setState(() => _activeType = v),
            onSortChanged: (v) => setState(() => _sortBy = v),
            onBedsChanged: (v) => setState(() => _minBeds = v),
            onReset: _resetFilters,
            onClose: () => setState(() => _showFilters = false),
          ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _activeStatus = '';
      _activeType = '';
      _sortBy = 'newest';
      _minBeds = 0;
    });
  }
}

// ─────────────────────────────────────────────
// Search Header bar (desktop)
// ─────────────────────────────────────────────
class _SearchHeader extends StatelessWidget {
  final String query;
  final int count;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final bool compact;

  const _SearchHeader({
    required this.query,
    required this.count,
    required this.controller,
    required this.onSearch,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          Text(
            query.isEmpty
                ? context.localization.search_results_all_properties
                : context.localization.search_results_for_query(query),
            style: const TextStyle(fontSize: tx28, fontWeight: FontWeight.w800, color: kSecondary),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: s8),
        ],
        Row(
          children: [
            Text(
              '$count ${count == 1 ? 'property' : 'properties'} found',
              style: TextStyle(fontSize: tx14, color: kGrey700, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            if (!compact)
            // Inline search bar for desktop
              Container(
                width: 320,
                height: s42,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(s8),
                  border: Border.all(color: kGrey200),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: s12),
                    const Icon(Icons.search, color: kGrey500, size: s18),
                    const SizedBox(width: s8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onSubmitted: onSearch,
                        decoration: InputDecoration(
                          hintText: context.localization.search_hint_refine,
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: tx14, color: kGrey500),
                        ),
                        style: const TextStyle(fontSize: tx14),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Results Grid
// ─────────────────────────────────────────────
class _ResultsGrid extends StatelessWidget {
  final List<Property> properties;
  final int columns;

  const _ResultsGrid({required this.properties, required this.columns});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const _EmptyState();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: s20,
        mainAxisSpacing: s20,
        mainAxisExtent: 450,
      ),
      itemCount: properties.length,
      itemBuilder: (context, i) {
        final p = properties[i];
        return GestureDetector(
          onTap: () => context.goNamed(RouteName.propertyDetail, pathParameters: {'id': p.id}),
          child: Hero(
            tag: 'property_image_${p.id}',
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
          ),
        )
            .animate()
            .fadeIn(
          delay: Duration(milliseconds: i * 60),
          duration: 500.ms,
        )
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

// ─────────────────────────────────────────────
// Filter Panel (sidebar)
// ─────────────────────────────────────────────
class _FilterPanel extends StatelessWidget {
  final String activeStatus;
  final String activeType;
  final String sortBy;
  final int minBeds;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<int> onBedsChanged;
  final VoidCallback onReset;

  const _FilterPanel({
    required this.activeStatus,
    required this.activeType,
    required this.sortBy,
    required this.minBeds,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onSortChanged,
    required this.onBedsChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.localization.search_filter_title,
              style: TextStyle(fontSize: tx20, fontWeight: FontWeight.w800, color: kSecondary),
            ),
            GestureDetector(
              onTap: onReset,
              child: Text(
                context.localization.search_filter_reset_all,
                style: TextStyle(fontSize: tx12, color: kPrimary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: s28),

        // Sort
        _FilterSection(
          title: context.localization.search_filter_sort_by,
          child: Column(
            children: [
              _RadioTile(
                label: context.localization.search_sort_newest,
                value: 'newest',
                groupValue: sortBy,
                onChanged: onSortChanged,
              ),
              _RadioTile(
                label: context.localization.search_sort_price_low,
                value: 'price_low',
                groupValue: sortBy,
                onChanged: onSortChanged,
              ),
              _RadioTile(
                label: context.localization.search_sort_price_high,
                value: 'price_high',
                groupValue: sortBy,
                onChanged: onSortChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: s24),

        // Status
        _FilterSection(
          title: context.localization.search_filter_status,
          child: Column(
            children: [
              _ChipRow<String>(
                options: const ['', 'For Sale', 'For Rent', 'Sold'],
                labels: [
                  context.localization.search_filter_all_status,
                  context.localization.search_tab_for_sale,
                  context.localization.search_tab_for_rent,
                  context.localization.search_filter_sold,
                ],
                selected: activeStatus,
                onSelect: onStatusChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: s24),

        // Property Type
        _FilterSection(
          title: context.localization.search_filter_type,
          child: Column(
            children: PropertyType.values.map((type) {
              final label = type.name[0].toUpperCase() + type.name.substring(1);
              final isSelected = activeType.toLowerCase() == type.name;
              return _CheckTile(
                label: label,
                isSelected: isSelected,
                onTap: () => onTypeChanged(isSelected ? '' : type.name),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: s24),

        // Bedrooms
        _FilterSection(
          title: context.localization.search_filter_min_beds,
          child: _ChipRow<int>(
            options: const [0, 1, 2, 3],
            labels: [context.localization.search_filter_any, '1+', '2+', '3+'],
            selected: minBeds,
            onSelect: (v) => onBedsChanged(v),
          ),
        ),

        const SizedBox(height: s32),
      ],
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: tx14, fontWeight: FontWeight.w700, color: kSecondary, letterSpacing: 0.3),
        ),
        const SizedBox(height: s12),
        child,
      ],
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _RadioTile({required this.label, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: s6),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: value == groupValue ? kPrimary : kGrey400, width: 2),
                color: value == groupValue ? kPrimary : kTransparent,
              ),
              child: value == groupValue ? const Icon(Icons.check, size: 10, color: kWhite) : null,
            ),
            const SizedBox(width: s10),
            Text(
              label,
              style: TextStyle(
                fontSize: tx14,
                color: value == groupValue ? kSecondary : kGrey700,
                fontWeight: value == groupValue ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CheckTile({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: s6),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isSelected ? kPrimary : kGrey400, width: 2),
                color: isSelected ? kPrimary : kTransparent,
              ),
              child: isSelected ? const Icon(Icons.check, size: 11, color: kWhite) : null,
            ),
            const SizedBox(width: s10),
            Text(
              label,
              style: TextStyle(
                fontSize: tx14,
                color: isSelected ? kSecondary : kGrey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipRow<T> extends StatelessWidget {
  final List<T> options;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onSelect;

  const _ChipRow({required this.options, required this.labels, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: s8,
      runSpacing: s8,
      children: options.asMap().entries.map((e) {
        final isSelected = e.value == selected;
        return GestureDetector(
          onTap: () => onSelect(e.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s6),
            decoration: BoxDecoration(
              color: isSelected ? kPrimary : kGrey100,
              borderRadius: BorderRadius.circular(s20),
              border: Border.all(color: isSelected ? kPrimary : kGrey300),
            ),
            child: Text(
              labels[e.key],
              style: TextStyle(
                fontSize: tx12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? kWhite : kGrey700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Mobile top search bar (in AppBar area)
// ─────────────────────────────────────────────
class _SearchTopBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onFilterTap;

  const _SearchTopBar({required this.controller, required this.onSearch, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSecondary,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + s12, bottom: s12, left: s16, right: s16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: s18),
          ),
          const SizedBox(width: s12),
          Expanded(
            child: Container(
              height: s42,
              decoration: BoxDecoration(color: kWhite.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(s8)),
              child: TextField(
                controller: controller,
                onSubmitted: onSearch,
                style: const TextStyle(color: kWhite, fontSize: tx14),
                decoration: InputDecoration(
                  hintText: context.localization.search_hint_properties,
                  hintStyle: TextStyle(color: Colors.white54, fontSize: tx14),
                  prefixIcon: Icon(Icons.search, color: Colors.white54, size: s18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: s12),
                ),
              ),
            ),
          ),
          const SizedBox(width: s12),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: s42,
              width: s42,
              decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(s8)),
              child: const Icon(Icons.tune, color: kWhite, size: s20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mobile filter bottom sheet overlay
// ─────────────────────────────────────────────
class _MobileFilterSheet extends StatelessWidget {
  final String activeStatus;
  final String activeType;
  final String sortBy;
  final int minBeds;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<int> onBedsChanged;
  final VoidCallback onReset;
  final VoidCallback onClose;

  const _MobileFilterSheet({
    required this.activeStatus,
    required this.activeType,
    required this.sortBy,
    required this.minBeds,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onSortChanged,
    required this.onBedsChanged,
    required this.onReset,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: kBlack.withValues(alpha: 0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(maxHeight: context.screenHeight * 0.8),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(s24)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: s12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: kGrey300, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: s20, vertical: s12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.localization.search_filter_title,
                          style: TextStyle(fontSize: tx18, fontWeight: FontWeight.w800, color: kSecondary),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: onReset,
                              child: Text(
                                context.localization.search_filter_reset,
                                style: TextStyle(color: kPrimary, fontSize: tx14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: s16),
                            GestureDetector(
                              onTap: onClose,
                              child: const Icon(Icons.close, size: s20, color: kGrey700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: kGrey200),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(s20),
                      child: _FilterPanel(
                        activeStatus: activeStatus,
                        activeType: activeType,
                        sortBy: sortBy,
                        minBeds: minBeds,
                        onStatusChanged: onStatusChanged,
                        onTypeChanged: onTypeChanged,
                        onSortChanged: onSortChanged,
                        onBedsChanged: onBedsChanged,
                        onReset: onReset,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: s60),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: kGrey100, shape: BoxShape.circle),
            child: const Icon(Icons.search_off, size: 48, color: kGrey400),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: s24),
          const Text(
            'No properties found',
            style: TextStyle(fontSize: tx20, fontWeight: FontWeight.w700, color: kSecondary),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: s8),
          Text(
            context.localization.search_no_results_subtitle,
            style: TextStyle(fontSize: tx14, color: kGrey500),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: s60),
        ],
      ),
    );
  }
}