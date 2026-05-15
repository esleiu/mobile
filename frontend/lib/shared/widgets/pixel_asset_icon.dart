import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PixelAssetIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const PixelAssetIcon({
    super.key,
    required this.assetPath,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.toLowerCase().endsWith('.png')) {
      return Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
