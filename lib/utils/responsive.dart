import 'package:flutter/material.dart';

class Responsive {
  static double categoryIconSize(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return (size.shortestSide * 0.12).clamp(40, 80); // Правильный порядок операций
}

  static double categoryFontSize(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return (size.shortestSide * 0.035).clamp(14, 24); // Фиксированный clamp
}

  static int gridCrossAxisCount(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait ? 2 : 3; // Фиксируем 2 колонки в портрете
  }

  static double gridChildAspectRatio(BuildContext context) {
    return 0.65; // Увеличил высоту относительно ширины
  }

  static EdgeInsets gridPadding(BuildContext context) {
    return const EdgeInsets.symmetric(horizontal: 8, vertical: 12); // Уменьшил отступы
  }
}