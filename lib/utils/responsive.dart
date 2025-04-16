import 'package:flutter/material.dart';

class Responsive {
  static double categoryIconSize(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide * 0.12;
  }

  static double categoryFontSize(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide * 0.035;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  static double gridChildAspectRatio(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait ? 0.8 : 1.2;
  }
}