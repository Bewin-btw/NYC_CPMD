import 'package:flutter/material.dart';
import '../widgets/adaptive_grid.dart';
import '../utils/responsive.dart';
import '../models/game_item.dart';
import '../services/game_service.dart';
import '../screens/about_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'language_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameItem> _items = [];
  bool _isLoading = true;
  bool _showDeleted = false;
  final List<GameItem> _deletedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final items = await GameService.fetchItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleDeletedItems() {
    setState(() {
      _showDeleted = !_showDeleted;
      if (_showDeleted) {
        _items.addAll(_deletedItems);
      } else {
        _items.removeWhere((item) => _deletedItems.contains(item));
      }
    });
  }

  void _handleItemRemoval(GameItem item) {
    setState(() {
      _items.remove(item);
      _deletedItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.itemRemoved(item.title)),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed:
              () => setState(() {
                _items.add(item);
                _deletedItems.remove(item);
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            // ⚡ Новая кнопка выбора языка
            icon: const Icon(Icons.language),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageSelector()),
                ),
          ),
          IconButton(
            icon: Icon(_showDeleted ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleDeletedItems,
            tooltip: AppLocalizations.of(context)!.toggleVisibility,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _navigateToAbout(context),
            tooltip: AppLocalizations.of(context)!.about,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadItems,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: AdaptiveGrid(
                    items: _items,
                    onItemRemoved: _handleItemRemoval,
                  ),
                ),
              ),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder:
            (_, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: const AboutPage()),
      ),
    );
  }
}
