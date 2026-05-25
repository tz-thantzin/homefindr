import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/router/app_router.dart';

class SearchBarCard extends StatefulWidget {
  const SearchBarCard({super.key});

  @override
  State<SearchBarCard> createState() => _SearchBarCardState();
}

class _SearchBarCardState extends State<SearchBarCard> {
  int _activeTab = 0;
  final _statusValues = ['', 'For Sale', 'For Rent'];
  final _controller = TextEditingController();
  bool _searchFocused = false;

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
      context.localization.search_tab_all,
      context.localization.search_tab_for_sale,
      context.localization.search_tab_for_rent,
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: context.isMobile ? context.percentWidth(92) : 820,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(s4),
        border: Border.all(
          color: _searchFocused
              ? kPrimary.withValues(alpha: 0.5)
              : kBorderDark,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _searchFocused
                ? kPrimary.withValues(alpha: 0.12)
                : kBlack.withValues(alpha: 0.4),
            blurRadius: _searchFocused ? 40 : 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tab row ──
          Row(
            children: tabs.asMap().entries.map((e) => _TabItem(
              label: e.value,
              isActive: _activeTab == e.key,
              onTap: () => setState(() => _activeTab = e.key),
            )).toList(),
          ),

          Container(height: 1, color: kBorderDark),

          // ── Input row ──
          _buildInputRow(context),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 700.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildInputRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s12),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: kPrimary.withValues(alpha: 0.9), size: s20),
          const SizedBox(width: s10),

          Expanded(
            child: Focus(
              onFocusChange: (focused) => setState(() => _searchFocused = focused),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _onSearch(),
                style: GoogleFonts.dmSans(fontSize: tx14, color: kCream, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: context.localization.search_hint_enter_address_neighborhood,
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.dmSans(fontSize: tx14, color: kMuted),
                ),
                cursorColor: kPrimary,
              ),
            ),
          ),

          Container(width: 1, height: s30, color: kBorderDark, margin: const EdgeInsets.symmetric(horizontal: s12)),

          _TypeDropdown(),

          const SizedBox(width: s12),

          GestureDetector(
            onTap: _onSearch,
            child: Container(
              height: s48,
              width: s48,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(s4),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.search, color: kSecondary, size: s22),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? kPrimary : kTransparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? kPrimary : kMuted,
            fontSize: tx14,
            letterSpacing: 0.3,
          ),
        ),
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
  String _selectedKey = '';

  @override
  Widget build(BuildContext context) {
    final types = [
      {'key': '', 'label': context.localization.search_any_type},
      {'key': 'apartment', 'label': context.localization.property_type_section_apartment},
      {'key': 'villa', 'label': context.localization.property_type_section_villa},
      {'key': 'studio', 'label': context.localization.property_type_section_studio},
      {'key': 'office', 'label': context.localization.property_type_section_office},
      {'key': 'townhouse', 'label': context.localization.property_type_section_townhouse},
    ];
    final selectedLabel = types.firstWhere(
      (t) => t['key'] == _selectedKey,
      orElse: () => types.first,
    )['label']!;

    return PopupMenuButton<String>(
      onSelected: (key) => setState(() => _selectedKey = key),
      offset: const Offset(0, 40),
      color: kCanvas,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(s4),
        side: const BorderSide(color: kBorderDark),
      ),
      elevation: 16,
      itemBuilder: (_) => types.map((type) => PopupMenuItem(
        value: type['key'],
        child: Row(
          children: [
            Icon(
              type['key'] == _selectedKey ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: s16,
              color: type['key'] == _selectedKey ? kPrimary : kMuted,
            ),
            const SizedBox(width: s8),
            Text(
              type['label']!,
              style: GoogleFonts.dmSans(
                fontSize: tx14,
                fontWeight: type['key'] == _selectedKey ? FontWeight.w700 : FontWeight.w400,
                color: type['key'] == _selectedKey ? kCream : kMuted,
              ),
            ),
          ],
        ),
      )).toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_outlined, size: s16, color: kMuted),
          const SizedBox(width: 4),
          Text(
            selectedLabel,
            style: GoogleFonts.dmSans(fontSize: tx14, fontWeight: FontWeight.w500, color: kMuted),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: s16, color: kMuted),
        ],
      ),
    );
  }
}
