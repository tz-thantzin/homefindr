import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/constants/constant_colors.dart';
import '../../../../core/constants/constant_sizes.dart';
import '../../../../core/extensions/context_ex.dart';
import '../../widgets/common/nav_logo.dart';
import '../../widgets/footer/footer_section.dart';
import '../../widgets/hero/desktop_nav_bar.dart';
import '../../widgets/hero/mobile_drawer.dart';

// ─────────────────────────────────────────────
// Contact Screen
// ─────────────────────────────────────────────
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: context.isDesktop ? null : const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ScreenTypeLayout.builder(desktop: (_) => _SolidNavBar(), mobile: (_) => _SolidMobileNavBar()),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            // Page header
            _ContactPageHeader(),

            // Main content
            Container(
              color: kGrey100,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.isDesktop ? s40 : s20, vertical: s60),
                    child: ScreenTypeLayout.builder(
                      desktop: (_) => _buildDesktopContent(context),
                      mobile: (_) => _buildMobileContent(context),
                    ),
                  ),
                ),
              ),
            ),

            // Info cards strip
            _InfoCardsStrip(),

            // FAQ Section
            _FaqSection(),

            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _ContactForm()),
        const SizedBox(width: s40),
        Expanded(flex: 2, child: _ContactSidebar()),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      children: [
        _ContactForm(),
        const SizedBox(height: s32),
        _ContactSidebar(),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Page Header (dark banner, no hero image)
// ─────────────────────────────────────────────
class _ContactPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kSecondary,
      padding: EdgeInsets.symmetric(horizontal: context.isDesktop ? s80 : s24, vertical: s60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              Text(
                context.localization.contact_breadcrumb_home,
                style: TextStyle(color: kWhite.withValues(alpha: 0.5), fontSize: tx12),
              ),
              Icon(Icons.chevron_right, size: s14, color: kWhite.withValues(alpha: 0.4)),
              Text(
                context.localization.contact_breadcrumb_contact,
                style: TextStyle(color: kPrimary, fontSize: tx12, fontWeight: FontWeight.w600),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: s16),

          Text(
            context.localization.contact_hero_title,
            style: const TextStyle(color: kWhite, fontSize: tx48, fontWeight: FontWeight.w800, height: 1.15),
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.2),

          const SizedBox(height: s12),

          Text(
            context.localization.contact_hero_subtitle,
            style: TextStyle(color: kWhite.withValues(alpha: 0.65), fontSize: tx16, height: 1.6),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Contact Form
// ─────────────────────────────────────────────
class _ContactForm extends StatefulWidget {
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _inquiryType = 'Buy'; // default, not localized for logic
  bool _isSubmitting = false;
  bool _submitted = false;

  List<String> _inquiryTypes(BuildContext context) => [
    context.localization.contact_inquiry_buy,
    context.localization.contact_inquiry_rent,
    context.localization.contact_inquiry_sell,
    context.localization.contact_inquiry_general,
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(s32),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(s16),
        boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: _submitted ? _SuccessState() : _buildForm(context),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.contact_form_title,
            style: const TextStyle(fontSize: tx24, fontWeight: FontWeight.w800, color: kSecondary),
          ),
          const SizedBox(height: s6),
          Text(
            context.localization.contact_form_subtitle,
            style: const TextStyle(fontSize: tx14, color: kGrey500),
          ),

          const SizedBox(height: s28),

          // Inquiry type chips
          Text(
            context.localization.contact_form_interested_in,
            style: const TextStyle(fontSize: tx12, fontWeight: FontWeight.w700, color: kGrey700, letterSpacing: 0.5),
          ),
          const SizedBox(height: s10),
          Wrap(
            spacing: s8,
            children: _inquiryTypes(context).map((type) {
              final isActive = _inquiryType == type;
              return GestureDetector(
                onTap: () => setState(() => _inquiryType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: s16, vertical: s8),
                  decoration: BoxDecoration(
                    color: isActive ? kPrimary : kGrey100,
                    borderRadius: BorderRadius.circular(s20),
                    border: Border.all(color: isActive ? kPrimary : kGrey300),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: tx12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? kWhite : kGrey700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: s24),

          // Name + Email row
          ScreenTypeLayout.builder(
            desktop: (_) => Row(
              children: [
                Expanded(
                  child: _FormField(
                    controller: _nameCtrl,
                    label: context.localization.contact_name,
                    hint: context.localization.contact_name_hint,
                    icon: Icons.person_outline,
                    validator: _required,
                  ),
                ),
                const SizedBox(width: s16),
                Expanded(
                  child: _FormField(
                    controller: _emailCtrl,
                    label: context.localization.contact_email,
                    hint: context.localization.contact_email_hint,
                    icon: Icons.email_outlined,
                    validator: _emailValidator,
                  ),
                ),
              ],
            ),
            mobile: (_) => Column(
              children: [
                _FormField(
                  controller: _nameCtrl,
                  label: context.localization.contact_name,
                  hint: context.localization.contact_name_hint,
                  icon: Icons.person_outline,
                  validator: _required,
                ),
                const SizedBox(height: s16),
                _FormField(
                  controller: _emailCtrl,
                  label: context.localization.contact_email,
                  hint: context.localization.contact_email_hint,
                  icon: Icons.email_outlined,
                  validator: _emailValidator,
                ),
              ],
            ),
          ),

          const SizedBox(height: s16),

          // Phone + Subject row
          ScreenTypeLayout.builder(
            desktop: (_) => Row(
              children: [
                Expanded(
                  child: _FormField(
                    controller: _phoneCtrl,
                    label: context.localization.contact_phone,
                    hint: context.localization.contact_phone_hint,
                    icon: Icons.phone_outlined,
                  ),
                ),
                const SizedBox(width: s16),
                Expanded(
                  child: _FormField(
                    controller: _subjectCtrl,
                    label: context.localization.contact_subject,
                    hint: context.localization.contact_subject_hint,
                    icon: Icons.subject_outlined,
                    validator: _required,
                  ),
                ),
              ],
            ),
            mobile: (_) => Column(
              children: [
                _FormField(
                  controller: _phoneCtrl,
                  label: context.localization.contact_phone,
                  hint: context.localization.contact_phone_hint,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: s16),
                _FormField(
                  controller: _subjectCtrl,
                  label: context.localization.contact_subject,
                  hint: context.localization.contact_subject_hint,
                  icon: Icons.subject_outlined,
                  validator: _required,
                ),
              ],
            ),
          ),

          const SizedBox(height: s16),

          _FormField(
            controller: _msgCtrl,
            label: context.localization.contact_message,
            hint: context.localization.contact_message_hint,
            icon: Icons.message_outlined,
            maxLines: 5,
            validator: _required,
          ),

          const SizedBox(height: s28),

          SizedBox(
            width: double.infinity,
            height: s55,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: kWhite,
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: kWhite, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.localization.contact_send,
                          style: const TextStyle(fontSize: tx16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                        ),
                        const SizedBox(width: s10),
                        const Icon(Icons.send, size: s16),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? v) => (v == null || v.isEmpty) ? context.localization.contact_validation_required : null;

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return context.localization.contact_validation_email_required;
    if (!v.contains('@')) return context.localization.contact_validation_email_invalid;
    return null;
  }
}

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: s60),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            const SizedBox(height: s24),
            Text(
              context.localization.contact_success_title,
              style: const TextStyle(fontSize: tx24, fontWeight: FontWeight.w800, color: kSecondary),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: s8),
            Text(
              context.localization.contact_success_subtitle,
              style: const TextStyle(fontSize: tx16, color: kGrey500),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: tx12, fontWeight: FontWeight.w600, color: kSecondary),
        ),
        const SizedBox(height: s8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: kGrey100,
              borderRadius: BorderRadius.circular(s8),
              border: Border.all(color: _focused ? kPrimary : kGrey200, width: _focused ? 1.5 : 1),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: kGrey400, fontSize: tx14),
                prefixIcon: widget.maxLines == 1
                    ? Icon(widget.icon, size: s16, color: _focused ? kPrimary : kGrey500)
                    : null,
                contentPadding: EdgeInsets.symmetric(horizontal: widget.maxLines > 1 ? s16 : 0, vertical: s14),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: const TextStyle(fontSize: tx14, color: kSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Contact Sidebar
// ─────────────────────────────────────────────
class _ContactSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kGrey200,
            borderRadius: BorderRadius.circular(s16),
            boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.06), blurRadius: 16)],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(painter: _SimpleMapPainter(), child: const SizedBox.expand()),
              Container(
                padding: const EdgeInsets.all(s12),
                decoration: BoxDecoration(
                  color: kPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4)],
                ),
                child: const Icon(Icons.location_on, color: kWhite, size: s24),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),

        const SizedBox(height: s24),

        // Contact info card
        Container(
          padding: const EdgeInsets.all(s24),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(s16),
            boxShadow: [BoxShadow(color: kBlack.withValues(alpha: 0.06), blurRadius: 16)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization.contact_info_title,
                style: const TextStyle(fontSize: tx18, fontWeight: FontWeight.w800, color: kSecondary),
              ),
              const SizedBox(height: s20),
              _InfoRow(
                icon: Icons.location_on_outlined,
                title: context.localization.contact_info_address_label,
                value: context.localization.contact_address,
              ),
              _InfoRow(
                icon: Icons.phone_outlined,
                title: context.localization.contact_info_phone_label,
                value: context.localization.contact_phone_number,
              ),
              _InfoRow(
                icon: Icons.email_outlined,
                title: context.localization.contact_info_email_label,
                value: context.localization.contact_email_address,
              ),
              _InfoRow(
                icon: Icons.access_time,
                title: context.localization.contact_info_hours_label,
                value: context.localization.contact_office_hours,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

        const SizedBox(height: s20),

        // Agent card
        Container(
          padding: const EdgeInsets.all(s24),
          decoration: BoxDecoration(color: kSecondary, borderRadius: BorderRadius.circular(s16)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: kPrimary.withValues(alpha: 0.2),
                child: const Icon(Icons.support_agent, color: kPrimary, size: 28),
              ),
              const SizedBox(width: s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.contact_agent_title,
                      style: const TextStyle(color: kWhite, fontSize: tx16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      context.localization.contact_agent_available,
                      style: TextStyle(color: kWhite.withValues(alpha: 0.55), fontSize: tx12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(s10),
                decoration: BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                child: const Icon(Icons.call, color: kWhite, size: s18),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(s8)),
            child: Icon(icon, size: s16, color: kPrimary),
          ),
          const SizedBox(width: s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: tx10, fontWeight: FontWeight.w700, color: kGrey500, letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: tx14, fontWeight: FontWeight.w600, color: kSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Info Cards Strip
// ─────────────────────────────────────────────
class _InfoCardsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'icon': Icons.access_time,
        'title': context.localization.contact_card_response_title,
        'desc': context.localization.contact_card_response_desc,
      },
      {
        'icon': Icons.verified_outlined,
        'title': context.localization.contact_card_licensed_title,
        'desc': context.localization.contact_card_licensed_desc,
      },
      {
        'icon': Icons.handshake_outlined,
        'title': context.localization.contact_card_fees_title,
        'desc': context.localization.contact_card_fees_desc,
      },
      {
        'icon': Icons.support_agent,
        'title': context.localization.contact_card_support_title,
        'desc': context.localization.contact_card_support_desc,
      },
    ];

    return Container(
      color: kWhite,
      padding: const EdgeInsets.symmetric(vertical: s60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: ScreenTypeLayout.builder(
              desktop: (_) => Row(
                children: cards
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: e.key == 0 ? 0 : s20),
                          child: _InfoCard(
                            icon: e.value['icon'] as IconData,
                            title: e.value['title'] as String,
                            desc: e.value['desc'] as String,
                            index: e.key,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              mobile: (_) => Column(
                children: cards
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: s16),
                        child: _InfoCard(
                          icon: e.value['icon'] as IconData,
                          title: e.value['title'] as String,
                          desc: e.value['desc'] as String,
                          index: e.key,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final int index;

  const _InfoCard({required this.icon, required this.title, required this.desc, required this.index});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(s28),
            decoration: BoxDecoration(
              color: _hovered ? kSecondary : kWhite,
              borderRadius: BorderRadius.circular(s12),
              border: Border.all(color: _hovered ? kSecondary : kGrey200),
              boxShadow: _hovered
                  ? [BoxShadow(color: kSecondary.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 8))]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _hovered ? kPrimary.withValues(alpha: 0.2) : kPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(s12),
                  ),
                  child: Icon(widget.icon, color: kPrimary, size: s20),
                ),
                const SizedBox(height: s16),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: tx16, fontWeight: FontWeight.w700, color: _hovered ? kWhite : kSecondary),
                ),
                const SizedBox(height: s6),
                Text(
                  widget.desc,
                  style: TextStyle(
                    fontSize: tx12,
                    color: _hovered ? kWhite.withValues(alpha: 0.6) : kGrey500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.index * 100),
          duration: 500.ms,
        )
        .slideY(begin: 0.15);
  }
}

// ─────────────────────────────────────────────
// FAQ Section
// ─────────────────────────────────────────────
class _FaqSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': context.localization.contact_faq_q1, 'a': context.localization.contact_faq_a1},
      {'q': context.localization.contact_faq_q2, 'a': context.localization.contact_faq_a2},
      {'q': context.localization.contact_faq_q3, 'a': context.localization.contact_faq_a3},
      {'q': context.localization.contact_faq_q4, 'a': context.localization.contact_faq_a4},
      {'q': context.localization.contact_faq_q5, 'a': context.localization.contact_faq_a5},
    ];

    return Container(
      color: kGrey100,
      padding: const EdgeInsets.symmetric(vertical: s60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.contact_faq_title,
                  style: const TextStyle(fontSize: tx32, fontWeight: FontWeight.w800, color: kSecondary),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: s8),
                Text(
                  context.localization.contact_faq_subtitle,
                  style: const TextStyle(fontSize: tx16, color: kGrey500),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: s32),
                ...faqs.asMap().entries.map(
                  (e) => _FaqItem(question: e.value['q']!, answer: e.value['a']!, index: e.key),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final int index;

  const _FaqItem({required this.question, required this.answer, required this.index});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heightFactor = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: s12),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(s12),
            border: Border.all(color: _expanded ? kPrimary.withValues(alpha: 0.3) : kGrey200),
            boxShadow: _expanded ? [BoxShadow(color: kPrimary.withValues(alpha: 0.08), blurRadius: 16)] : [],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(s20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.question,
                          style: TextStyle(
                            fontSize: tx16,
                            fontWeight: _expanded ? FontWeight.w700 : FontWeight.w600,
                            color: _expanded ? kPrimary : kSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: s12),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(Icons.keyboard_arrow_down, color: _expanded ? kPrimary : kGrey500, size: s20),
                      ),
                    ],
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _heightFactor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(s20, 0, s20, s20),
                  child: Text(
                    widget.answer,
                    style: const TextStyle(fontSize: tx14, color: kGrey700, height: 1.7),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.index * 80),
          duration: 400.ms,
        )
        .slideY(begin: 0.1);
  }
}

// ─────────────────────────────────────────────
// Solid nav bars (no hero behind them)
// ─────────────────────────────────────────────
class _SolidNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: kSecondary, child: const DesktopNavBar());
  }
}

class _SolidMobileNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSecondary,
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

class _SimpleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8EEF4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final road = Paint()
      ..color = kWhite
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), road);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), road);

    final block = Paint()..color = const Color(0xFFD4DDE8);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 30, 100, 80), const Radius.circular(4)), block);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.55, 30, 120, 60), const Radius.circular(4)),
      block,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(20, size.height * 0.6, 80, 60), const Radius.circular(4)),
      block,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.55, size.height * 0.62, 140, 50), const Radius.circular(4)),
      block,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
