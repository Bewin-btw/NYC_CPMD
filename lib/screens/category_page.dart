import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/game_data_service.dart';
import '../providers/theme_provider.dart';

class CategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String displayedText = '';
  List<String> truthQuestions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (truthQuestions.isEmpty) {
      loadTruthQuestions();
    }
  }

  Future<void> loadTruthQuestions() async {
    final locale = Localizations.localeOf(context);
    final data = await GameDataService.loadGameData(locale);
    setState(() {
      truthQuestions = List<String>.from(data['truth_questions']);
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
    final actions = List<String>.from(widget.category['actions']);
    final random = Random();
    setState(() {
      displayedText = actions[random.nextInt(actions.length)];
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
        title: Text(widget.category['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => Navigator.pushNamed(context, '/language'),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              final isDark = Theme.of(context).brightness != Brightness.dark;
              themeProvider.toggleTheme(isDark);
            },
          ),
        ],
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
