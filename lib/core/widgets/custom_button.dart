import 'package:flutter/material.dart';
import 'package:homefindr/core/extensions/theme_ex.dart';

import '../constants/constant_sizes.dart';

class CustomBrandButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomBrandButton({super.key, required this.label, this.icon, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(s10)),
        padding: const EdgeInsets.symmetric(horizontal: s40, vertical: s24),
        foregroundColor: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: tx20, fontWeight: bold, color: color, letterSpacing: 0.5),
          ),
          const SizedBox(width: s20),
          if (icon != null) Icon(icon, size: s28, color: color, weight: 200,),
        ],
      ),
    );
  }
}
