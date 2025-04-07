import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../utils/responsive.dart';

/// Адаптивная сетка, подстраивающаяся под размер экрана и ориентацию
/// Использует [LayoutBuilder] и [MediaQuery] для определения параметров
class AdaptiveGrid extends StatelessWidget {
  final List<GameItem> items;

  const AdaptiveGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
        final crossAxisCount = Responsive.getCrossAxisCount(
          context,
          portrait: isPortrait ? 2 : 3,
          landscape: isPortrait ? 3 : 4,
        );

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isPortrait ? 0.8 : 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildGameCard(items[index]),
        );
      },
    );
  }

  Widget _buildGameCard(GameItem item) {
    return Hero(
      tag: item.id,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {}, // Навигация к деталям
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Изображение занимает 70% карточки
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Текстовая часть с гибким размером
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}