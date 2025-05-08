import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/audio_provider.dart';

import 'screens/about_page.dart';
import 'screens/home_page.dart';
import 'screens/setting_page.dart';
import 'screens/profile_page.dart'; // 👈 обязательно добавь
import 'screens/auth_wrapper.dart';

import 'utils/constants.dart';
import 'services/auth_service.dart';
 final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('languageCode');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..loadLocale()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
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
      themeMode: themeProvider.themeMode,
      home: const AuthWrapper(),
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final index = navigationProvider.currentIndex;

    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    final screens = [
      const AboutPage(),
      const HomePage(),
      const SettingsPage(),
      if (!isGuest) const ProfilePage(),
    ];

    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      if (!isGuest)
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    // Безопасный индекс
    final safeIndex = index >= screens.length ? 0 : index;

    return Scaffold(
      body: screens[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: safeIndex,
  onTap: navigationProvider.setIndex,
  items: items,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  selectedItemColor: Theme.of(context).colorScheme.primary,
  unselectedItemColor: Theme.of(context).unselectedWidgetColor,
  selectedIconTheme: const IconThemeData(size: 26),
  unselectedIconTheme: const IconThemeData(size: 22),
),

    );
  }
}
