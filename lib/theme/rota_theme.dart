import 'package:flutter/material.dart';

abstract final class RotaColors {
  static const ink = Color(0xFF07383A);
  static const inkSoft = Color(0xFF155754);
  static const forest = Color(0xFF2F754D);
  static const sage = Color(0xFF82A878);
  static const cream = Color(0xFFF7F1E5);
  static const paper = Color(0xFFFFFCF6);
  static const mist = Color(0xFFE5F1EC);
  static const sea = Color(0xFFDDEFF0);
  static const gold = Color(0xFFE8B85A);
  static const terracotta = Color(0xFFB86D48);
  static const textMuted = Color(0xFF657774);
}

abstract final class RotaShadows {
  static List<BoxShadow> soft([Color color = const Color(0xFF07383A)]) => [
    BoxShadow(
      color: color.withValues(alpha: 0.12),
      blurRadius: 22,
      offset: const Offset(0, 9),
    ),
  ];
}
