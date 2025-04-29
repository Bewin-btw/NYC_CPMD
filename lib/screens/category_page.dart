import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/game_data_service.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class CategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String displayedText = '';
  List<String> truthQuestions = [];
  List<String> dareActions = [];
  String categoryName = '';
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      currentLocale = provider.locale;
      loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<LocaleProvider>(context);
    final newLocale = provider.locale ?? Localizations.localeOf(context);

    if (currentLocale != newLocale) {
      currentLocale = newLocale;
      loadData();
    }
  }

  Future<void> loadData() async {
    final locale = currentLocale ?? Localizations.localeOf(context);
    final data = await GameDataService.loadGameData(locale);

    final newCategory = data['categories']
        .firstWhere((c) => c['id'] == widget.category['id'], orElse: () => null);

    if (newCategory == null) return;

    setState(() {
      truthQuestions = List<String>.from(data['truth_questions']);
      dareActions = List<String>.from(newCategory['actions']);
      categoryName = newCategory['name'] ?? '';
      displayedText = '';
    });
  }

  void showRandomTruth() {
    if (truthQuestions.isEmpty) return;
    final random = Random();
    setState(() {
      displayedText = truthQuestions[random.nextInt(truthQuestions.length)];
    });
  }

  void showRandomDare() {
    if (dareActions.isEmpty) return;
    final random = Random();
    setState(() {
      displayedText = dareActions[random.nextInt(dareActions.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  displayedText.isEmpty ? loc.chooseAction : displayedText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: showRandomTruth,
                  icon: const Icon(Icons.question_answer),
                  label: Text(loc.truth),
                ),
                ElevatedButton.icon(
                  onPressed: showRandomDare,
                  icon: const Icon(Icons.flash_on),
                  label: Text(loc.dare),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}