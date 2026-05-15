import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/shared/widgets/icone_ativo_pixel.dart';

class ArcadeChip extends StatelessWidget {
  final String text;
  final String? pixelAsset;
  final IconData? icon;
  final String? pngAsset;

  const ArcadeChip({
    super.key,
    required this.text,
    this.pixelAsset,
    this.icon,
    this.pngAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFF808080), width: 1),
          left: BorderSide(color: Color(0xFF808080), width: 1),
          bottom: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.white, width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pixelAsset != null || pngAsset != null || icon != null) ...[
            if (pngAsset != null)
              Image.asset(pngAsset!, width: 12, height: 12, fit: BoxFit.contain)
            else if (pixelAsset != null)
              PixelAssetIcon(
                assetPath: pixelAsset!,
                size: 12,
                color: Colors.black,
              )
            else
              Icon(icon, size: 12, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
