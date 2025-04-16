import 'package:flutter/material.dart';

class Responsive {
  // Рассчитываем размер иконок на основе размеров экрана.
  static double categoryIconSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide * 0.12;
  }

  // Рассчитываем размер шрифта для категорий.
  static double categoryFontSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide * 0.035;
  }

  // Определяем количество столбцов в сетке с учетом ориентации и ширины экрана.
  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      if (width > 600) return 3;
      return 2;
    } else {
      if (width > 1200) return 4;
      if (width > 800) return 3;
      if (width > 600) return 2;
      return 1;
    }
  }

  // Вычисляем соотношение сторон ячейки с учетом размеров экрана.
  // Здесь рассчитывается ширина ячейки с учетом отступов и межячейкового пространства,
  // затем определяется коэффициент, зависящий от соотношения высоты и ширины экрана.
  // Это позволяет адаптировать высоту ячеек на разных устройствах.
  static double gridChildAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = gridCrossAxisCount(context);

    // Учтем внешние отступы (padding) и промежутки между элементами (spacing).
    const double horizontalPadding = 16.0 * 2; // отступы слева и справа
    const double spacing =
        16.0 *
        (2); // предполагаем, что между ячейками (минимум два отступа при двух столбцах)

    // Расчет доступной ширины для ячеек.
    final availableWidth = size.width - horizontalPadding - spacing;
    final itemWidth = availableWidth / crossAxisCount;

    // Для адаптации высоты учитываем общее соотношение сторон экрана.
    // Фактор определяется как доля высоты, которую логично занять одной ячейке.
    // При портретной ориентации коэффициент вычисляется динамически,
    // чтобы при больших высотах ячейки становились чуть выше, а при меньших – компактнее.
    double heightFactor;
    if (orientation == Orientation.portrait) {
      // Коэффициент зависит от отношения высоты к ширине экрана.
      heightFactor = (size.height / size.width) * 0.5;
    } else {
      // Для ландшафтной ориентации можно использовать фиксированный коэффициент.
      heightFactor = 1.2;
    }
    final itemHeight = itemWidth * heightFactor;

    // Соотношение сторон для сетки.
    return itemWidth / itemHeight;
  }

  static EdgeInsets gridPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return EdgeInsets.symmetric(horizontal: width > 600 ? 16 : 8);
  }
}
