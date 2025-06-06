import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? 'Language Settings'),
      ),
      body: ListView.builder(
        itemCount: LanguageNotifier.supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = LanguageNotifier.supportedLocales[index];
          final isSelected = currentLocale.languageCode == locale.languageCode;
          
          return ListTile(
            leading: Text(
              languageNotifier.getLanguageFlag(locale.languageCode),
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              languageNotifier.getLanguageName(locale.languageCode),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            trailing: isSelected 
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
            onTap: () async {
              await languageNotifier.changeLanguage(locale.languageCode);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}