import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/services/win95_sound_service.dart';

import 'pixel_asset_icon.dart';

class AppButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final String? pixelAsset;
  final String? pngAsset;
  final String? badgePixelAsset;
  final VoidCallback? onPressed;
  final bool expanded;

  const AppButton({
    super.key,
    required this.text,
    this.icon,
    this.pixelAsset,
    this.pngAsset,
    this.badgePixelAsset,
    this.onPressed,
    this.expanded = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.onPressed == null) return;
    Win95SoundService.instance.playClick();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
      onTap: _handleTap,
      child: Container(
        width: widget.expanded ? double.infinity : null,
        decoration: BoxDecoration(
          color: const Color(0xFFC0C0C0),
          border: Border(
            top: BorderSide(
              color: _isPressed ? Colors.black : Colors.white,
              width: 2,
            ),
            left: BorderSide(
              color: _isPressed ? Colors.black : Colors.white,
              width: 2,
            ),
            bottom: BorderSide(
              color: _isPressed ? Colors.white : Colors.black,
              width: 2,
            ),
            right: BorderSide(
              color: _isPressed ? Colors.white : Colors.black,
              width: 2,
            ),
          ),
        ),
        padding: EdgeInsets.only(
          top: _isPressed ? 15 : 14,
          bottom: _isPressed ? 13 : 14,
          left: _isPressed ? 17 : 16,
          right: _isPressed ? 15 : 16,
        ),
        child: Row(
          mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.pixelAsset != null ||
                widget.pngAsset != null ||
                widget.icon != null) ...[
              SizedBox(
                width: 24,
                height: 24,
                child: widget.pngAsset != null
                    ? Image.asset(
                        widget.pngAsset!,
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      )
                    : widget.pixelAsset != null
                    ? PixelAssetIcon(
                        assetPath: widget.pixelAsset!,
                        size: 18,
                        color: enabled ? Colors.black : const Color(0xFF808080),
                      )
                    : Icon(
                        widget.icon,
                        size: 18,
                        color: enabled ? Colors.black : const Color(0xFF808080),
                      ),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: enabled ? Colors.black : const Color(0xFF808080),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
