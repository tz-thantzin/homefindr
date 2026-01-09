import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/extensions/context_ex.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSecondary,
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
              const Divider(color: Colors.white24),
              const SizedBox(height: s30),
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
        _FooterLinksCol(title: context.localization.footer_quick_links, links: const ["Home", "Buy", "Rent", "Sell"]),
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
          style: const TextStyle(color: Colors.white54, fontSize: tx14),
        ),
        Row(
          children: [
            _SocialIcon(icon: FontAwesomeIcons.facebookF, onTap: () {}),
            const SizedBox(width: s20),
            _SocialIcon(icon: FontAwesomeIcons.twitter, onTap: () {}),
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
        const Row(
          children: [
            Icon(Icons.home_work, color: kWhite, size: s28),
            SizedBox(width: s10),
            Text(
              "homez",
              style: TextStyle(color: kWhite, fontSize: tx24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: s20),
        Text(
          context.localization.footer_description,
          style: const TextStyle(color: Colors.white70, fontSize: tx14, height: 1.6),
        ),
        const SizedBox(height: s30),
        Text(
          context.localization.footer_newsletter_title,
          style: const TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontSize: tx14),
        ),
        const SizedBox(height: s15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: s15),
          margin: const EdgeInsets.only(right: s25),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(s30)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: kWhite, fontSize: tx14),
                  decoration: InputDecoration(
                    hintText: context.localization.footer_newsletter_hint,
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: tx14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send, color: kPrimary, size: s20),
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
          style: const TextStyle(color: kWhite, fontSize: tx18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: s25),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: s15),
            child: InkWell(
              onTap: () {},
              child: Text(
                link,
                style: const TextStyle(color: Colors.white60, fontSize: tx14),
              ),
            ),
          ),
        ),
      ],
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
          style: const TextStyle(color: kWhite, fontSize: tx18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: s25),
        const _ContactItem(icon: Icons.location_on_outlined, text: "Bangkok, Thailand"),
        const _ContactItem(icon: Icons.phone_outlined, text: "+66 123-123-123"),
        const _ContactItem(icon: Icons.email_outlined, text: "support@homez.com"),
        _ContactItem(icon: Icons.access_time, text: context.localization.footer_monday_friday),
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
      padding: const EdgeInsets.only(bottom: s20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimary, size: s20),
          const SizedBox(width: s15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white60, fontSize: tx14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FaIcon(icon, color: Colors.white54, size: s18),
    );
  }
}
