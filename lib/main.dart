import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/locale_provider.dart'; // ⚡ Новый импорт
import 'screens/about_page.dart';
import 'utils/constants.dart';
import 'providers/theme_provider.dart';


void main() async { // ⚡ Добавлено async
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('languageCode');
  
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()..loadLocale()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()), // 👈 добавили тему
    ],
    child: const MyApp(),
  ),
);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // 👈 получаем провайдер темы

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Truth or Dare',
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode, // 👈 динамический режим темы
      home: const AboutPage(),
    );
  }
}
