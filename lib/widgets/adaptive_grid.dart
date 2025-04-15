import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../utils/responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdaptiveGrid extends StatelessWidget {
  final List<GameItem> items;
  final Function(GameItem) onItemRemoved;

  const AdaptiveGrid({
    super.key,
    required this.items,
    required this.onItemRemoved,
  });

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
          itemBuilder: (context, index) => _buildGameCard(items[index], context),
        );
      },
    );
  }

  Widget _buildGameCard(GameItem item, BuildContext context) {
    return Hero(
      tag: item.id,
      child: GestureDetector(
        onDoubleTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
      '${AppLocalizations.of(context)!.doubleTap}: ${item.title}'
    )),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {},
            onLongPress: () => onItemRemoved(item),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stackTrace) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}