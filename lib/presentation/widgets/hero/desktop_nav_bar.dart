import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../common/nav_logo.dart';

// ─────────────────────────────────────────────
// Scroll-Aware Sticky Navbar
// ─────────────────────────────────────────────
class DesktopNavBar extends StatefulWidget {
  const DesktopNavBar({super.key});

  @override
  State<DesktopNavBar> createState() => _DesktopNavBarState();
}

class _DesktopNavBarState extends State<DesktopNavBar> {
  bool _isScrolled = false;
  ScrollController? _scrollController;

  void _onScroll() {
    final scrolled = (_scrollController?.offset ?? 0) > 60;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Remove from old controller first in case dependencies change
    _scrollController?.removeListener(_onScroll);
    _scrollController = PrimaryScrollController.of(context);
    _scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Use saved reference — context is deactivated here and cannot be used
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Transparent overlay only on home — on all other routes use solid kSecondary
    final isHome = GoRouterState.of(context).uri.path == RoutePath.initial;
    final bool showTransparent = isHome && !_isScrolled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: showTransparent
            ? kBlack.withValues(alpha: 0.18)
            : kSecondary,
        boxShadow: showTransparent
            ? []
            : [BoxShadow(color: kBlack.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 4))],
      ),
      child: _NavBarContent(isScrolled: _isScrolled),
    );
  }
}

// ─────────────────────────────────────────────
// Nav bar content row
// ─────────────────────────────────────────────
class _NavBarContent extends StatelessWidget {
  final bool isScrolled;

  const _NavBarContent({required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState
        .of(context)
        .uri
        .path;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: s42),
      child: Row(
        children: [
          const NavLogo()
              .animate()
              .fadeIn(duration: 500.ms)
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(width: s42),

          _NavItem(
            label: context.localization.nav_home,
            routeName: RouteName.home,
            routePath: RoutePath.initial,
            currentPath: location,
            delay: 50,
          ),
          _DropdownNavItem(
            label: context.localization.nav_buy,
            routeName: RouteName.buy,
            routePath: RoutePath.buy,
            currentPath: location,
            delay: 100,
            menuItems: _buyMenuItems(context),
          ),
          _DropdownNavItem(
            label: context.localization.nav_rent,
            routeName: RouteName.rent,
            routePath: RoutePath.rent,
            currentPath: location,
            delay: 150,
            menuItems: _rentMenuItems(context),
          ),

          const Spacer(),

          const _LanguageSwitcher()
              .animate()
              .fadeIn(delay: 250.ms, duration: 400.ms),

          const SizedBox(width: s20),

          Row(
            children: [
              const Icon(Icons.person_outline, color: kWhite, size: s20),
              const SizedBox(width: s8),
              Text(
                context.localization.nav_login_register,
                style: const TextStyle(color: kWhite, fontWeight: FontWeight.w600, fontSize: tx14),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

          const SizedBox(width: s20),

          _ContactButton()
              .animate()
              .fadeIn(delay: 350.ms, duration: 400.ms)
              .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }

  List<_MegaMenuItem> _buyMenuItems(BuildContext context) => [
    _MegaMenuItem(icon: Icons.apartment,        label: context.localization.nav_menu_apartments,  subtitle: context.localization.nav_menu_apartments_sub,  typeFilter: 'apartment'),
    _MegaMenuItem(icon: Icons.villa,            label: context.localization.nav_menu_villas,       subtitle: context.localization.nav_menu_villas_sub,       typeFilter: 'villa'),
    _MegaMenuItem(icon: Icons.home_work,        label: context.localization.nav_menu_studios,      subtitle: context.localization.nav_menu_studios_sub,      typeFilter: 'studio'),
    _MegaMenuItem(icon: Icons.business_center,  label: context.localization.nav_menu_offices,      subtitle: context.localization.nav_menu_offices_sub,      typeFilter: 'office'),
    _MegaMenuItem(icon: Icons.home,             label: context.localization.nav_menu_townhouses,   subtitle: context.localization.nav_menu_townhouses_sub,   typeFilter: 'townhouse'),
  ];

  List<_MegaMenuItem> _rentMenuItems(BuildContext context) => [
    _MegaMenuItem(icon: Icons.apartment,        label: context.localization.nav_menu_rent_apartments,  subtitle: context.localization.nav_menu_rent_apartments_sub,  typeFilter: 'apartment'),
    _MegaMenuItem(icon: Icons.villa,            label: context.localization.nav_menu_rent_villas,       subtitle: context.localization.nav_menu_rent_villas_sub,       typeFilter: 'villa'),
    _MegaMenuItem(icon: Icons.home_work,        label: context.localization.nav_menu_rent_studios,      subtitle: context.localization.nav_menu_rent_studios_sub,      typeFilter: 'studio'),
    _MegaMenuItem(icon: Icons.business_center,  label: context.localization.nav_menu_rent_offices,      subtitle: context.localization.nav_menu_rent_offices_sub,      typeFilter: 'office'),
    _MegaMenuItem(icon: Icons.home,             label: context.localization.nav_menu_rent_townhouses,   subtitle: context.localization.nav_menu_rent_townhouses_sub,   typeFilter: 'townhouse'),
  ];
}

// ─────────────────────────────────────────────
// Simple Nav Item
// ─────────────────────────────────────────────
class _NavItem extends StatefulWidget {
  final String label;
  final String routeName;
  final String routePath;
  final String currentPath;
  final int delay;

  const _NavItem({
    required this.label,
    required this.routeName,
    required this.routePath,
    required this.currentPath,
    this.delay = 0,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _underlineWidth;
  bool _isHovered = false;

  bool get _isActive => widget.currentPath == widget.routePath;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _underlineWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
    if (_isActive) _hoverCtrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (_isActive) {
      _hoverCtrl.forward();
    } else if (!_isHovered) {
      _hoverCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverCtrl.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!_isActive) _hoverCtrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.goNamed(widget.routeName),
        child: AnimatedBuilder(
          animation: _underlineWidth,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s28),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: _isActive || _isHovered ? kWhite : kWhite.withValues(alpha: 0.75),
                        fontWeight: _isActive ? FontWeight.w700 : FontWeight.w500,
                        fontSize: tx14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _underlineWidth.value,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mega Menu data model
// ─────────────────────────────────────────────
class _MegaMenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final String typeFilter; // PropertyType.name to pre-select on the listing screen
  const _MegaMenuItem({required this.icon, required this.label, required this.subtitle, required this.typeFilter});
}

// ─────────────────────────────────────────────
// Dropdown Nav Item
// Uses OverlayPortal + CompositedTransformFollower
// so the mega menu renders ABOVE the AppBar clip
// ─────────────────────────────────────────────
class _DropdownNavItem extends StatefulWidget {
  final String label;
  final String routeName;
  final String routePath;
  final String currentPath;
  final int delay;
  final List<_MegaMenuItem> menuItems;

  const _DropdownNavItem({
    required this.label,
    required this.routeName,
    required this.routePath,
    required this.currentPath,
    required this.menuItems,
    this.delay = 0,
  });

  @override
  State<_DropdownNavItem> createState() => _DropdownNavItemState();
}

class _DropdownNavItemState extends State<_DropdownNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _underlineWidth;
  late Animation<double> _dropdownAnim;

  final OverlayPortalController _overlayCtrl = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  bool _isHovered = false;
  bool _isMenuHovered = false;
  Timer? _closeTimer;

  bool get _isActive => widget.currentPath == widget.routePath;

  bool get _showMenu => _isHovered || _isMenuHovered;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _underlineWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _dropdownAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    if (_isActive) _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _ctrl.dispose();
    // Hide overlay synchronously on dispose — GoRouter tears down the widget
    // on navigation, this ensures the overlay entry is removed cleanly
    if (_overlayCtrl.isShowing) _overlayCtrl.hide();
    super.dispose();
  }

  void _open() {
    _closeTimer?.cancel();
    _ctrl.forward();
    if (!_overlayCtrl.isShowing) _overlayCtrl.show();
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 120), () {
      if (mounted && !_isHovered && !_isMenuHovered) {
        _ctrl.reverse().whenCompleteOrCancel(() {
          if (mounted && _overlayCtrl.isShowing) _overlayCtrl.hide();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayCtrl,
        overlayChildBuilder: (overlayContext) {
          return AnimatedBuilder(
            animation: _dropdownAnim,
            builder: (_, child) {
              return CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: Offset.zero,
                showWhenUnlinked: false,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Opacity(
                    opacity: _dropdownAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _dropdownAnim.value) * -8),
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isMenuHovered = true);
                _closeTimer?.cancel();
              },
              onExit: (_) {
                setState(() => _isMenuHovered = false);
                _scheduleClose();
              },
              child: _MegaMenuPanel(
                items: widget.menuItems,
                routeName: widget.routeName,
              ),
            ),
          );
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _open();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _scheduleClose();
          },
          child: GestureDetector(
            onTap: () => context.goNamed(widget.routeName),
            child: AnimatedBuilder(
              animation: _underlineWidth,
              builder: (context, _) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s28),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.label,
                                style: TextStyle(
                                  color: _isActive || _isHovered
                                      ? kWhite
                                      : kWhite.withValues(alpha: 0.75),
                                  fontWeight: _isActive ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: tx14,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedRotation(
                                turns: _showMenu ? 0.5 : 0,
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kWhite.withValues(alpha: 0.85),
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _underlineWidth.value,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: kPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mega Menu Panel
// ─────────────────────────────────────────────
class _MegaMenuPanel extends StatelessWidget {
  final List<_MegaMenuItem> items;
  final String routeName;

  const _MegaMenuPanel({required this.items, required this.routeName});

  // typeFilter is carried by each _MegaMenuItem item

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: kSecondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border.all(color: kWhite.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(s20, s16, s20, s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Browse by type',
                  style: TextStyle(
                    color: kWhite.withValues(alpha: 0.45),
                    fontSize: tx12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.goNamed(routeName),
                  child: Text(
                    'View all →',
                    style: TextStyle(color: kPrimary, fontSize: tx12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: kWhite.withValues(alpha: 0.07), height: 1),
          ...items
              .asMap()
              .entries
              .map(
                (entry) => _MegaMenuTile(item: entry.value, index: entry.key, routeName: routeName),
          ),
          const SizedBox(height: s8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mega Menu Tile
// ─────────────────────────────────────────────
class _MegaMenuTile extends StatefulWidget {
  final _MegaMenuItem item;
  final int index;
  final String routeName;

  const _MegaMenuTile({required this.item, required this.index, required this.routeName});


  @override
  State<_MegaMenuTile> createState() => _MegaMenuTileState();
}

class _MegaMenuTileState extends State<_MegaMenuTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            context.goNamed(
              widget.routeName,
              queryParameters: {'type': widget.item.typeFilter},
            ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: s20, vertical: s12),
          decoration: BoxDecoration(
            color: _hovered ? kPrimary.withValues(alpha: 0.12) : kTransparent,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _hovered
                      ? kPrimary.withValues(alpha: 0.2)
                      : kWhite.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.item.icon,
                  color: _hovered ? kPrimary : kWhite.withValues(alpha: 0.65),
                  size: 18,
                ),
              ),
              const SizedBox(width: s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.label,
                      style: TextStyle(
                        color: _hovered ? kWhite : kWhite.withValues(alpha: 0.85),
                        fontSize: tx14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.item.subtitle,
                      style: TextStyle(color: kWhite.withValues(alpha: 0.4), fontSize: tx12),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _hovered ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(Icons.north_east, color: kPrimary, size: 14),
              ),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: widget.index * 40))
          .fadeIn(duration: 200.ms)
          .slideX(begin: -0.05, end: 0),
    );
  }
}

// ─────────────────────────────────────────────
// Language Switcher — also uses OverlayPortal
// ─────────────────────────────────────────────
class _LanguageSwitcher extends ConsumerStatefulWidget {
  const _LanguageSwitcher();

  @override
  ConsumerState<_LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends ConsumerState<_LanguageSwitcher> {
  bool _open = false;
  Timer? _closeTimer;

  final OverlayPortalController _overlayCtrl = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  final List<Map<String, String>> _langs = [
    {'flag': '🇺🇸', 'code': 'EN', 'label': 'English'},
    {'flag': '🇲🇲', 'code': 'MY', 'label': 'မြန်မာ'},
    {'flag': '🇹🇭', 'code': 'TH', 'label': 'ภาษาไทย'},
    {'flag': '🇨🇳', 'code': 'ZH', 'label': '中文'},
    {'flag': '🇯🇵', 'code': 'JA', 'label': '日本語'},
  ];

  @override
  void dispose() {
    _closeTimer?.cancel();
    if (_overlayCtrl.isShowing) _overlayCtrl.hide();
    super.dispose();
  }

  void _openMenu() {
    _closeTimer?.cancel();
    setState(() => _open = true);
    if (!_overlayCtrl.isShowing) _overlayCtrl.show();
  }

  /// Delayed close — gives cursor time to travel from button into the panel.
  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _open = false);
        if (_overlayCtrl.isShowing) _overlayCtrl.hide();
      }
    });
  }

  void _cancelClose() => _closeTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayCtrl,
        overlayChildBuilder: (_) =>
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: Offset.zero,
              showWhenUnlinked: false,
              child: Align(
                alignment: Alignment.topLeft,
                child: MouseRegion(
                  onEnter: (_) => _cancelClose(),
                  onExit: (_) => _scheduleClose(),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: kSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kWhite.withValues(alpha: 0.08)),
                      boxShadow: [
                        BoxShadow(color: kBlack.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _langs
                          .asMap()
                          .entries
                          .map((e) {
                        final lang = e.value;
                        final currentCode = ref
                            .watch(localeProvider)
                            .languageCode
                            .toUpperCase();
                        final isSelected = currentCode == lang['code'];
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              ref.read(localeProvider.notifier).setByCode(lang['code']!);
                              _scheduleClose();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s10),
                              decoration: BoxDecoration(
                                color: isSelected ? kPrimary.withValues(alpha: 0.15) : kTransparent,
                                borderRadius: e.key == 0
                                    ? const BorderRadius.vertical(top: Radius.circular(12))
                                    : e.key == _langs.length - 1
                                    ? const BorderRadius.vertical(bottom: Radius.circular(12))
                                    : BorderRadius.zero,
                              ),
                              child: Row(
                                children: [
                                  Text(lang['flag']!, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: s8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lang['code']!,
                                          style: TextStyle(
                                            color: isSelected ? kPrimary : kWhite,
                                            fontSize: tx12,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Text(lang['label']!,
                                          style: TextStyle(color: kWhite.withValues(alpha: 0.4), fontSize: 10)),
                                    ],
                                  ),
                                  if (isSelected) ...[
                                    const Spacer(),
                                    Icon(Icons.check, color: kPrimary, size: 14),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(duration: 150.ms).slideY(begin: -0.1, end: 0),
                ),
              ),
            ),
        child: MouseRegion(
          onEnter: (_) => _openMenu(),
          onExit: (_) => _scheduleClose(),
          child: GestureDetector(
            onTap: () => _open ? _scheduleClose() : _openMenu(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: s12, vertical: s8),
              decoration: BoxDecoration(
                border: Border.all(color: kWhite.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(s20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(() {
                    final code = ref
                        .watch(localeProvider)
                        .languageCode
                        .toUpperCase();
                    final lang = _langs.firstWhere((l) => l['code'] == code, orElse: () => _langs.first);
                    return '${lang['flag']} ${lang['code']}';
                  }(), style: const TextStyle(fontSize: tx12, color: kWhite)),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: kWhite.withValues(alpha: 0.7), size: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Contact CTA Button
// ─────────────────────────────────────────────
class _ContactButton extends StatefulWidget {
  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.goNamed(RouteName.contact),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: s20, vertical: s12),
          decoration: BoxDecoration(
            color: _hovered ? kPrimary : kTransparent,
            border: Border.all(
              color: _hovered ? kPrimary : kWhite.withValues(alpha: 0.7),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(s28),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localization.nav_contact_us,
                style: TextStyle(
                  color: kWhite,
                  fontSize: tx14,
                  fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: s8),
              Icon(_hovered ? Icons.call : Icons.north_east, color: kWhite, size: s14),
            ],
          ),
        ),
      ),
    );
  }
}