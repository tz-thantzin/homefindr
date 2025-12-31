import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constant_colors.dart';
import '../constants/constant_sizes.dart';
import '../constants/duration.dart';
import '../extensions/theme_ex.dart';

class AnimatedSlideButton extends StatefulWidget {
  const AnimatedSlideButton({
    super.key,
    required this.title,
    this.titleStyle,
    this.width = s120,
    this.borderWidth = s1,
    this.height = s48,
    this.onPressed,
    this.hasIcon = true,
    this.textColor = kWhite,
    this.iconColor,
    this.buttonColor = kBlack,
    this.borderColor = kBlack,
    this.onHoverColor = kWhite,
    this.icon = FontAwesomeIcons.telegram,
    this.iconSize = s14,
    this.duration = duration1000,
    this.curve = Curves.fastOutSlowIn,
    this.buttonStyle,
    this.isLoading = false,
  });

  final String title;
  final TextStyle? titleStyle;
  final IconData icon;
  final double iconSize;
  final Color textColor;
  final Color? iconColor;
  final Color buttonColor;
  final Color borderColor;
  final Color onHoverColor;
  final double width;
  final double borderWidth;
  final double height;
  final ButtonStyle? buttonStyle;
  final VoidCallback? onPressed;
  final Duration duration;
  final Curve curve;
  final bool hasIcon;
  final bool isLoading;

  @override
  State<AnimatedSlideButton> createState() => _AnimatedSlideButtonState();
}

class _AnimatedSlideButtonState extends State<AnimatedSlideButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _textAndIconColor;
  late Animation<Offset> _offsetAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _textAndIconColor =
        ColorTween(
          begin: widget.textColor,
          end: widget.buttonColor,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve))..addListener(() {
          setState(() {});
        });

    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0.5, 0),
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve))..addListener(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // Fallback style if titleStyle not provided
    TextStyle style =
        textTheme.bodyMedium?.copyWith(color: _textAndIconColor.value, fontSize: s14, fontWeight: medium) ??
        TextStyle(color: _textAndIconColor.value);

    final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: widget.onHoverColor,
      backgroundColor: widget.onHoverColor,
      padding: const EdgeInsets.all(0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        side: BorderSide(width: widget.borderWidth, color: widget.borderColor),
      ),
    );

    return MouseRegion(
      key: const ValueKey('MouseRegion_Animated_Slide_Button'),
      onEnter: (e) => _mouseEnter(true),
      onExit: (e) => _mouseEnter(false),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.buttonStyle ?? defaultButtonStyle,
          child: Stack(
            children: [
              animatedBackground(),
              if (widget.hasIcon)
                childWithIcon(style)
              else
                Center(
                  child: Text(
                    widget.title,
                    style: widget.titleStyle?.copyWith(color: _textAndIconColor.value) ?? style,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget animatedBackground() {
    return Positioned(
      right: 0,
      child: AnimatedContainer(
        duration: widget.duration,
        width: _isHovering ? 0 : widget.width,
        height: widget.height,
        color: widget.buttonColor,
        curve: widget.curve,
      ),
    );
  }

  Widget childWithIcon(TextStyle defaultStyle) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.title,
              style: widget.titleStyle?.copyWith(color: _textAndIconColor.value) ?? defaultStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          SizedBox(width: s8),
          SlideTransition(
            position: _offsetAnimation,
            child: widget.isLoading
                ? SpinKitWanderingCubes(color: _textAndIconColor.value, size: 16.0)
                : Icon(widget.icon, size: widget.iconSize, color: widget.iconColor ?? _textAndIconColor.value),
          ),
        ],
      ),
    );
  }

  void _mouseEnter(bool hovering) {
    if (widget.onPressed == null) return;

    setState(() {
      _isHovering = hovering;
    });

    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}
