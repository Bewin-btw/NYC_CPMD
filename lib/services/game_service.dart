import '../models/game_item.dart';

class GameService {
  static Future<List<GameItem>> fetchItems() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return List.generate(20, (i) => GameItem(
      id: '$i',
      title: 'Challenge ${i + 1}',
      imageUrl: 'https://picsum.photos/200?random=$i',
    ));
  }
}