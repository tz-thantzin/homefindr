import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';
import '../common/nav_logo.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kFooterBg,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: s80, horizontal: s20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Column(
            children: [
              ScreenTypeLayout.builder(
                desktop: (context) => _buildDesktopFooter(context),
                mobile: (context) => _buildMobileFooter(context),
              ),

              const SizedBox(height: s60),

              // Gold divider
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: kBorderDark)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: s20),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: kBorderDark)),
                ],
              ),

              const SizedBox(height: s32),

              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 2, child: FooterBrandCol()),
        Expanded(
          child: _FooterLinksCol(
            title: context.localization.footer_quick_links,
            links: [
              context.localization.nav_home,
              context.localization.nav_buy,
              context.localization.nav_rent,
              context.localization.nav_sell,
              context.localization.nav_contact_us,
            ],
          ),
        ),
        Expanded(
          child: _FooterLinksCol(
            title: context.localization.footer_support,
            links: [
              context.localization.footer_faq,
              context.localization.footer_privacy_policy,
              context.localization.footer_terms_service,
              context.localization.footer_help_center,
            ],
          ),
        ),
        const Expanded(flex: 2, child: _FooterContactCol()),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FooterBrandCol(),
        const SizedBox(height: s40),
        _FooterLinksCol(
          title: context.localization.footer_quick_links,
          links: const ["Home", "Buy", "Rent", "Sell"],
        ),
        const SizedBox(height: s40),
        const _FooterContactCol(),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.localization.footer_rights_reserved,
          style: GoogleFonts.dmSans(
            color: kMuted.withValues(alpha: 0.5),
            fontSize: tx12,
          ),
        ),
        Row(
          children: [
            _SocialIcon(icon: FontAwesomeIcons.facebookF, onTap: () {}),
            const SizedBox(width: s20),
            _SocialIcon(icon: FontAwesomeIcons.xTwitter, onTap: () {}),
            const SizedBox(width: s20),
            _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () {}),
            const SizedBox(width: s20),
            _SocialIcon(icon: FontAwesomeIcons.linkedinIn, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class FooterBrandCol extends StatelessWidget {
  const FooterBrandCol({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NavLogo(disableTap: true),
        const SizedBox(height: s20),
        Text(
          context.localization.footer_description,
          style: GoogleFonts.dmSans(
            color: kMuted.withValues(alpha: 0.65),
            fontSize: tx14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: s32),
        Text(
          context.localization.footer_newsletter_title,
          style: GoogleFonts.playfairDisplay(
            color: kCream,
            fontWeight: FontWeight.w600,
            fontSize: tx16,
          ),
        ),
        const SizedBox(height: s14),
        Container(
          padding: const EdgeInsets.only(left: s16, right: s8),
          margin: const EdgeInsets.only(right: s24),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(s2),
            border: Border.all(color: kBorderDark),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.dmSans(color: kCream, fontSize: tx14),
                  cursorColor: kPrimary,
                  decoration: InputDecoration(
                    hintText: context.localization.footer_newsletter_hint,
                    hintStyle: GoogleFonts.dmSans(color: kMuted.withValues(alpha: 0.5), fontSize: tx14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: s14, vertical: s10),
                decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(s2)),
                ),
                child: const Icon(Icons.send, color: kSecondary, size: s16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterLinksCol extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterLinksCol({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: kCream,
            fontSize: tx16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: s20),

        // Thin gold underline
        Container(width: 24, height: 1.5, color: kPrimary),

        const SizedBox(height: s20),

        ...links.map(
          (link) => _FooterLink(link: link),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String link;
  const _FooterLink({required this.link});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.goNamed(widget.link),
        child: Padding(
          padding: const EdgeInsets.only(bottom: s14),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.dmSans(
              color: _hovered ? kPrimary : kMuted.withValues(alpha: 0.6),
              fontSize: tx14,
            ),
            child: Text(widget.link),
          ),
        ),
      ),
    );
  }
}

class _FooterContactCol extends StatelessWidget {
  const _FooterContactCol();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.footer_contact_us,
          style: GoogleFonts.playfairDisplay(
            color: kCream,
            fontSize: tx16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: s20),
        Container(width: 24, height: 1.5, color: kPrimary),
        const SizedBox(height: s20),
        const _ContactItem(icon: Icons.location_on_outlined, text: "Bangkok, Thailand"),
        const _ContactItem(icon: Icons.phone_outlined, text: "+95 123-123-123"),
        const _ContactItem(icon: Icons.email_outlined, text: "support@homefindr.com"),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimary, size: s16),
          const SizedBox(width: s12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                color: kMuted.withValues(alpha: 0.6),
                fontSize: tx14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(s8),
          decoration: BoxDecoration(
            color: _hovered ? kPrimary.withValues(alpha: 0.15) : kTransparent,
            borderRadius: BorderRadius.circular(s2),
            border: Border.all(color: _hovered ? kPrimary.withValues(alpha: 0.5) : kBorderDark),
          ),
          child: FaIcon(widget.icon, color: _hovered ? kPrimary : kMuted.withValues(alpha: 0.5), size: s14),
        ),
      ),
    );
  }
}

