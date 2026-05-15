import 'package:flutter/material.dart';

import 'icone_ativo_pixel.dart';

class ArcadeBanner extends StatelessWidget {
  final String title;
  final String iconAsset;
  final String? pngAsset;
  final String? secondaryPngAsset;
  final String? badgePixelAsset;

  const ArcadeBanner({
    super.key,
    required this.title,
    required this.iconAsset,
    this.pngAsset,
    this.secondaryPngAsset,
    this.badgePixelAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF000080),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          if (pngAsset != null)
            Image.asset(pngAsset!, width: 22, height: 22, fit: BoxFit.contain)
          else
            PixelAssetIcon(assetPath: iconAsset, size: 20, color: Colors.white),
          if (secondaryPngAsset != null) ...[
            const SizedBox(width: 4),
            Image.asset(
              secondaryPngAsset!,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ],
          if (badgePixelAsset != null) ...[
            const SizedBox(width: 4),
            PixelAssetIcon(
              assetPath: badgePixelAsset!,
              size: 14,
              color: Colors.white,
            ),
          ],
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            color: const Color(0xFFC0C0C0),
            padding: const EdgeInsets.all(2),
            child: const Icon(Icons.close, size: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
