import 'package:flutter/material.dart';

enum TerminalThemeId { classicGreen, vscodeColorful }

class TerminalThemePalette {
  final TerminalThemeId id;
  final String label;
  final String description;
  final Color background;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final Color cursor;

  const TerminalThemePalette({
    required this.id,
    required this.label,
    required this.description,
    required this.background,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.cursor,
  });
}

class TerminalThemes {
  static const TerminalThemePalette classicGreen = TerminalThemePalette(
    id: TerminalThemeId.classicGreen,
    label: 'Terminal Verde Classico',
    description: 'Fundo preto com texto verde retrô.',
    background: Colors.black,
    primaryText: Color(0xFF00FF66),
    secondaryText: Color(0xFF00AA44),
    border: Color(0xFF00AA44),
    cursor: Color(0xFF00FF66),
  );

  static const TerminalThemePalette vscodeColorful = TerminalThemePalette(
    id: TerminalThemeId.vscodeColorful,
    label: 'VS Code Colorido',
    description: 'Fundo escuro com acento ciano e texto colorido.',
    background: Color(0xFF1E1E1E),
    primaryText: Color(0xFF4FC1FF),
    secondaryText: Color(0xFFCE9178),
    border: Color(0xFF569CD6),
    cursor: Color(0xFF9CDCFE),
  );

  static const List<TerminalThemePalette> all = <TerminalThemePalette>[
    classicGreen,
    vscodeColorful,
  ];

  static TerminalThemePalette byId(TerminalThemeId id) {
    switch (id) {
      case TerminalThemeId.classicGreen:
        return classicGreen;
      case TerminalThemeId.vscodeColorful:
        return vscodeColorful;
    }
  }

  static TerminalThemeId parse(String? raw) {
    switch (raw) {
      case 'vscode_colorful':
        return TerminalThemeId.vscodeColorful;
      case 'classic_green':
      default:
        return TerminalThemeId.classicGreen;
    }
  }

  static String serialize(TerminalThemeId id) {
    switch (id) {
      case TerminalThemeId.classicGreen:
        return 'classic_green';
      case TerminalThemeId.vscodeColorful:
        return 'vscode_colorful';
    }
  }
}
