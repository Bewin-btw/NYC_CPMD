import 'package:flutter/material.dart';

class Responsive {
  /// Возвращает отступы в зависимости от размера экрана
  static double getPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 2000) return 32;
    if (width > 1200) return 24;
    if (width > 600) return 16;
    return 12;
  }

  /// Рассчитывает количество колонок для GridView
  static int getCrossAxisCount(BuildContext context, {required int portrait, required int landscape}) {
    final orientation = MediaQuery.orientationOf(context);
    final width = MediaQuery.sizeOf(context).width;
    
    if (width > 2000) return 6; // Для очень широких экранов
    if (width > 1200) return 5; // Для десктопов
    if (width > 800) return 4;  // Для планшетов
    return orientation == Orientation.portrait ? portrait : landscape;
  }
}