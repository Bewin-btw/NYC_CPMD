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
    if (currentLocale != locale) {
      currentLocale = locale;
      loadCategories();
    }
  }

  Future<void> loadCategories() async {
    setState(() => isLoading = true);
    final data = await GameDataService.loadGameData(currentLocale!);
    setState(() {
      categories = data['categories'];
      isLoading = false;
    });
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
              child: GridView.builder(
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
                    key: UniqueKey(),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (!showDeleted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryPage(category: category),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          if (showDeleted) {
                            setState(() {
                              deletedCategories.remove(category);
                              categories.add(category);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${category['name']} восстановлена')),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Icon(
                                  icon,
                                  size: Responsive.categoryIconSize(context),
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  category['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.categoryFontSize(context),
                                    fontWeight: FontWeight.w600,
                                  ),
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