import 'dart:math';

import 'package:flutter/material.dart';

class FlipRevealCard extends StatefulWidget {
  final bool isRevealed;
  final String hiddenText;
  final String revealedText;
  final String title;
  final double height;
  final IconData frontIcon;
  final IconData backIcon;
  final Color backColor;
  final bool isImpostor;
  final bool enableTapFlip;
  final ValueChanged<bool>? onFlipChanged;

  const FlipRevealCard({
    super.key,
    required this.isRevealed,
    required this.hiddenText,
    required this.revealedText,
    this.title = 'Arquivo Secreto',
    this.height = 340,
    this.frontIcon = Icons.lock_outline,
    this.backIcon = Icons.description_outlined,
    this.backColor = Colors.white,
    this.isImpostor = false,
    this.enableTapFlip = false,
    this.onFlipChanged,
  });

  @override
  State<FlipRevealCard> createState() => _FlipRevealCardState();
}

class _FlipRevealCardState extends State<FlipRevealCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
      value: widget.isRevealed ? 1 : 0,
    );
    _animation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant FlipRevealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRevealed == widget.isRevealed) return;
    if (widget.isRevealed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _win95Box({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          left: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }

  Widget _titleBar(String text) {
    return Container(
      height: 28,
      color: const Color(0xFF000080),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
          ),
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFC0C0C0),
              border: Border(
                top: BorderSide(color: Colors.white, width: 1),
                left: BorderSide(color: Colors.white, width: 1),
                right: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: const Icon(Icons.close, size: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _insetPanel({required Widget child, Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: const Border(
          top: BorderSide(color: Color(0xFF808080), width: 2),
          left: BorderSide(color: Color(0xFF808080), width: 2),
          right: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: child,
    );
  }

  Widget _frontSide() {
    return _win95Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleBar('Identidade.exe'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _insetPanel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.frontIcon, size: 64, color: Colors.black),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.hiddenText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backSide() {
    final isImpostorMessage =
        widget.isImpostor ||
        widget.revealedText.toLowerCase().contains('impostor');
    final color = isImpostorMessage ? Colors.red : Colors.green.shade700;

    return _win95Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleBar('Resultado.exe'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _insetPanel(
                color: widget.backColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.backIcon, size: 62, color: color),
                      const SizedBox(height: 12),
                      Text(
                        widget.revealedText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final frontSide = _frontSide();
    final backSide = _backSide();

    return GestureDetector(
      onTap: widget.enableTapFlip
          ? () => widget.onFlipChanged?.call(!widget.isRevealed)
          : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value;
          final isShowingFront = angle < pi / 2;

          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;
              final width = maxWidth * 0.985;
              final preferredHeight = max(widget.height, width * 1.18);
              final height = maxHeight.isFinite
                  ? min(maxHeight, preferredHeight)
                  : preferredHeight;

              return Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isShowingFront
                        ? frontSide
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: backSide,
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
