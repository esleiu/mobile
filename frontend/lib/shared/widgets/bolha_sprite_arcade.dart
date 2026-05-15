import 'package:flutter/material.dart';

class ArcadeSpriteBubble extends StatelessWidget {
  final String assetPath;
  final double size;

  const ArcadeSpriteBubble({
    super.key,
    required this.assetPath,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          left: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFF808080), width: 1),
            left: BorderSide(color: Color(0xFF808080), width: 1),
            bottom: BorderSide(color: Colors.white, width: 1),
            right: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(3),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
