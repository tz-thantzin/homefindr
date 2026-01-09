import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constant_images.dart';
import '../../../core/constants/constant_sizes.dart';
import '../../../core/router/app_router.dart';

class NavLogo extends StatelessWidget {
  const NavLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(AppRouter.home);
      },
      borderRadius: BorderRadius.circular(s40),
      child: Image.asset(kNavLogo, height: s40, fit: BoxFit.contain),
    );
  }
}
