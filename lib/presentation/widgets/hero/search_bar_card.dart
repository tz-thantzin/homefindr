import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/extensions/theme_ex.dart';
import '../../../core/router/app_router.dart';

class SearchBarCard extends StatefulWidget {
  const SearchBarCard({super.key});

  @override
  State<SearchBarCard> createState() => _SearchBarCardState();
}

class _SearchBarCardState extends State<SearchBarCard> {
  int _activeTab = 0; // 0: All, 1: For Sale, 2: For Rent
  final _statusValues = ['', 'For Sale', 'For Rent'];
  final _controller = TextEditingController();
  bool _searchFocused = false;

  // _tabs built in build() for localization

  void _onSearch() {
    final query = _controller.text.trim();
    final status = _statusValues[_activeTab];

    context.goNamed(
      RouteName.search,
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        if (status.isNotEmpty) 'status': status,
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'label': context.localization.search_tab_all,      'status': ''},
      {'label': context.localization.search_tab_for_sale, 'status': 'For Sale'},
      {'label': context.localization.search_tab_for_rent, 'status': 'For Rent'},
    ];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: context.isMobile ? context.percentWidth(90) : 800,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s12),
        boxShadow: [
          BoxShadow(
            color: _searchFocused
                ? kPrimary.withValues(alpha: 0.18)
                : kBlack.withValues(alpha: 0.12),
            blurRadius: _searchFocused ? 32 : 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: tabs
                .asMap()
                .entries
                .map((e) => _tabItem(e.value['label'] as String, e.key, tabs))
                .toList(),
          ),
          Container(height: 1, color: kGrey200),
          _buildInputRow(context),
        ],
      ),
    );
  }



  Widget _tabItem(String title, int index, List tabs) {
    final bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: s25, vertical: s15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? kPrimary : kTransparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? kPrimary : kGrey700,
            fontSize: tx14,
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s10),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: kPrimary.withValues(alpha: 0.8), size: s20),
          const SizedBox(width: s10),
          Expanded(
            child: Focus(
              onFocusChange: (focused) => setState(() => _searchFocused = focused),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _onSearch(),
                decoration: InputDecoration(
                  hintText: context.localization.search_hint_enter_address_neighborhood,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: tx14,
                    color: kGrey500,
                  ),
                ),
                style: const TextStyle(fontSize: tx14, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Divider
          Container(width: 1, height: s30, color: kGrey200, margin: const EdgeInsets.symmetric(horizontal: s12)),

          // Property type quick filter
          _TypeDropdown(),

          const SizedBox(width: s12),

          // Search button
          GestureDetector(
            onTap: _onSearch,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: s50,
              width: s50,
              decoration: BoxDecoration(
                color: kPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(Icons.search, color: kWhite, size: s22),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Quick type filter inside search bar
// ─────────────────────────────────────────────
class _TypeDropdown extends StatefulWidget {
  @override
  State<_TypeDropdown> createState() => _TypeDropdownState();
}

class _TypeDropdownState extends State<_TypeDropdown> {
  String _selectedKey = ''; // store key, not display label

  @override
  Widget build(BuildContext context) {
    final types = [
      {'key': '',          'label': context.localization.search_any_type},
      {'key': 'apartment', 'label': context.localization.property_type_section_apartment},
      {'key': 'villa',     'label': context.localization.property_type_section_villa},
      {'key': 'studio',    'label': context.localization.property_type_section_studio},
      {'key': 'office',    'label': context.localization.property_type_section_office},
      {'key': 'townhouse', 'label': context.localization.property_type_section_townhouse},
    ];
    final selectedLabel = types.firstWhere(
          (t) => t['key'] == _selectedKey,
      orElse: () => types.first,
    )['label']!;

    return GestureDetector(
      child: PopupMenuButton<String>(
        onSelected: (key) => setState(() => _selectedKey = key),
        offset: const Offset(0, 40),
        color: kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(s12)),
        elevation: 8,
        itemBuilder: (_) => types.map((type) => PopupMenuItem(
          value: type['key'],
          child: Row(
            children: [
              Icon(
                type['key'] == _selectedKey ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: s16,
                color: type['key'] == _selectedKey ? kPrimary : kGrey400,
              ),
              const SizedBox(width: s8),
              Text(type['label']!, style: TextStyle(
                fontSize: tx14,
                fontWeight: type['key'] == _selectedKey ? FontWeight.w700 : FontWeight.w400,
              )),
            ],
          ),
        )).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_outlined, size: s16, color: kGrey700),
            const SizedBox(width: 4),
            Text(
              selectedLabel,
              style: const TextStyle(fontSize: tx14, fontWeight: FontWeight.w500, color: kGrey800),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: s16, color: kGrey500),
          ],
        ),
      ),
    );
  }
}