import 'package:flutter/material.dart';
import '../widgets/adaptive_grid.dart';
import '../utils/responsive.dart';
import '../models/game_item.dart';
import '../services/game_service.dart';
import '../screens/about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<GameItem>> _gameItems;

  @override
  void initState() {
    super.initState();
    _gameItems = GameService.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truth or Dare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _navigateToAbout(context),
          ),
        ],
      ),
      body: FutureBuilder<List<GameItem>>(
        future: _gameItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return RefreshIndicator(
            onRefresh: () async => setState(() {
              _gameItems = GameService.fetchItems();
            }),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: AdaptiveGrid(items: snapshot.data!),
            ),
          );
        },
      ),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: const AboutPage(),
        ),
      ),
    );
  }
}