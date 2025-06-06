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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)?.settings ?? 'Language Settings'),
      ),
      body: ListView.builder(
        itemCount: LanguageNotifier.supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = LanguageNotifier.supportedLocales[index];
          final isSelected = currentLocale.languageCode == locale.languageCode;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF00D632).withOpacity(0.2)
                  : Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? const Color(0xFF00D632)
                    : Colors.grey[800]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              leading: Text(
                languageNotifier.getLanguageFlag(locale.languageCode),
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                languageNotifier.getLanguageName(locale.languageCode),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              trailing: isSelected 
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xFF00D632),
                      size: 24,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
              onTap: () async {
                await languageNotifier.changeLanguage(locale.languageCode);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          );
        },
      ),
    );
  }
}