import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.languageSettings)),
      body: ListView(
        children: [
          _buildLanguageTile(context, 'English', 'en', provider),
          _buildLanguageTile(context, 'Русский', 'ru', provider),
          _buildLanguageTile(context, 'Қазақша', 'kk', provider),
        ],
      ),
    );
  }

  ListTile _buildLanguageTile(
    BuildContext context, 
    String title, 
    String code,
    LocaleProvider provider
  ) {
    return ListTile(
      title: Text(title),
      trailing: provider.locale?.languageCode == code 
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () => provider.setLocale(Locale(code)),
    );
  }
}