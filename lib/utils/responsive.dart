import 'package:flutter/material.dart';

class Responsive {
  static double categoryIconSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide * 0.12;
  }

  static double categoryFontSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide * 0.035;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return width > 600 ? 3 : 2;
    } else {
      if (width > 1200) return 4;
      if (width > 800) return 3;
      return 2;
    }
  }

  // 🔥 Вот тут магия – стабильные пропорции карточек
  static double gridChildAspectRatio(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait ? 3 / 4 : 1.2;
  }

  static EdgeInsets gridPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return EdgeInsets.symmetric(horizontal: width > 600 ? 16 : 8);
  }
}
