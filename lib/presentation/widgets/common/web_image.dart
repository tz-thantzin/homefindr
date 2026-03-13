import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constant_colors.dart';
import '../../../core/constants/constant_sizes.dart';

class WebImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const WebImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover});

  Widget get _placeholder => Container(color: kGrey200);

  Widget get _errorWidget => Container(
    color: kGrey100,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined, size: 40, color: kGrey400),
        SizedBox(height: s6),
        Text('Image unavailable', style: TextStyle(fontSize: 11, color: kGrey400)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, progress) => progress == null ? child : _placeholder,
        errorBuilder: (_, _, _) => _errorWidget,
        frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: child,
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (_, _) => _placeholder,
      errorWidget: (_, _, _) => _errorWidget,
    );
  }
}
