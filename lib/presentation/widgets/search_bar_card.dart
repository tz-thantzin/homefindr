import 'package:flutter/material.dart';

import '../../core/constants/constant_colors.dart';
import '../../core/constants/constant_sizes.dart';
import '../../core/extensions/context_ex.dart';
import '../../core/extensions/theme_ex.dart';

class SearchBarCard extends StatefulWidget {
  const SearchBarCard({super.key});

  @override
  State<SearchBarCard> createState() => _SearchBarCardState();
}

class _SearchBarCardState extends State<SearchBarCard> {
  int activeTab = 0; // 0: All, 1: For Sale, 2: For Rent

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.isMobile ? context.percentWidth(90) : 800,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s12),
        boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _buildTabs(),
          const Divider(height: s1),
          _buildInputRow(context),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tabItem("All", 0),
        _tabItem("For Sale", 1),
        _tabItem("For Rent", 2),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    bool isActive = activeTab == index;
    return InkWell(
      onTap: () => setState(() => activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: s25, vertical: s15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isActive ? kBlack : kTransparent, width: s2)),
        ),
        child: Text(
          title,
          style: TextStyle(fontWeight: isActive ? bold : medium),
        ),
      ),
    );
  }

  Widget _buildInputRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(s12),
      child: Row(
        children: [
          const Icon(Icons.home_outlined, color: kGrey500),
          const SizedBox(width: s10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter an address, neighborhood, city, or ZIP code",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: tx14),
              ),
            ),
          ),
          if (!context.isMobile) ...[
            const Icon(Icons.tune, size: s20),
            const SizedBox(width: s5),
            const Text("Advanced", style: TextStyle(fontWeight: bold)),
            const SizedBox(width: s15),
          ],
          Container(
            height: s50,
            width: s50,
            decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
            child: const Icon(Icons.search, color: kWhite),
          )
        ],
      ),
    );
  }
}