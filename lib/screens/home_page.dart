import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_data_service.dart';
import 'category_page.dart';
import '../screens/about_page.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'language_selector.dart';
import '../utils/responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [];
  List deletedCategories = [];
  bool showDeleted = false;
  bool isLoading = true;
  Locale? currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (currentLocale?.languageCode != locale.languageCode) {
      currentLocale = locale;
      loadCategories();
    }
  }

  Future<void> loadCategories() async {
    try {
      setState(() => isLoading = true);
      final locale = currentLocale ?? Localizations.localeOf(context);
      final data = await GameDataService.loadGameData(locale);
      
      if (data.containsKey('categories')) {
        setState(() {
          categories = List<Map<String, dynamic>>.from(data['categories']);
          isLoading = false;
        });
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  void toggleDeletedCategories() => setState(() => showDeleted = !showDeleted);

  void handleCategoryRemoval(dynamic category) {
    setState(() {
      categories.remove(category);
      deletedCategories.add(category);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.itemRemoved(category['name'])),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () => setState(() {
            categories.add(category);
            deletedCategories.remove(category);
          }),
        ),
      ),
    );
  }

  IconData getCategoryIcon(String id) {
    switch (id) {
      case 'dance': return Icons.music_note;
      case 'call': return Icons.call;
      case 'fitness': return Icons.fitness_center;
      case 'selfie': return Icons.photo_camera;
      case 'robot': return Icons.android;
      case 'social': return Icons.share;
      case 'food': return Icons.fastfood;
      case 'voice': return Icons.mic;
      case 'truthbomb': return Icons.bolt;
      case 'random': return Icons.shuffle;
      default: return Icons.extension;
    }
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, secondaryAnimation) =>
            FadeTransition(opacity: animation, child: const AboutPage()),
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
            icon: const Icon(Icons.language),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguageSelector()),
            ),
          ),
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme(Theme.of(context).brightness != Brightness.dark);
            },
          ),
          IconButton(
            icon: Icon(showDeleted ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleDeletedCategories,
            tooltip: AppLocalizations.of(context)!.toggleVisibility,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _navigateToAbout(context),
            tooltip: AppLocalizations.of(context)!.about,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadCategories,
              child: categories.isEmpty
                  ? Center(child: Text('No categories found'))
                  : GridView.builder(
                      padding: Responsive.gridPadding(context),
                      itemCount: showDeleted ? deletedCategories.length : categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.gridCrossAxisCount(context),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: Responsive.gridChildAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                        final category = showDeleted 
                            ? deletedCategories[index] 
                            : categories[index];
                        final icon = getCategoryIcon(category['id']);

                        return Dismissible(
                          key: ValueKey(category['id']),
                          direction: showDeleted 
                              ? DismissDirection.none 
                              : DismissDirection.endToStart,
                          onDismissed: (_) => handleCategoryRemoval(category),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => !showDeleted 
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryPage(category: category),
                                      ),
                                    )
                                  : null,
                              onLongPress: () {
                                if (showDeleted) {
                                  setState(() {
                                    deletedCategories.remove(category);
                                    categories.add(category);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${category['name']} восстановлена'),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Icon(
                                        icon,
                                        size: Responsive.categoryIconSize(context),
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Flexible(
                                      child: Text(
                                        category['name'] ?? 'Unnamed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: Responsive.categoryFontSize(context),
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}