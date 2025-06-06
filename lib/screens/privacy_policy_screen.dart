import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.privacyPolicy ?? 'Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.privacyTitle ?? 'Trader App Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              l10n?.privacyEffectiveDate ?? 'Effective Date: February 21, 2025',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _SectionTitle(l10n?.privacySection1Title ?? '1. Purpose of Collection and Use of Personal Information'),
            _SectionContent(l10n?.privacySection1Content ?? ''),
            _SectionTitle(l10n?.privacySection2Title ?? '2. Items of Personal Information Collected'),
            _SectionContent(l10n?.privacySection2Content ?? ''),
            _SectionTitle(l10n?.privacySection3Title ?? '3. Retention and Use Period of Personal Information'),
            _SectionContent(l10n?.privacySection3Content ?? ''),
            _SectionTitle(l10n?.privacySection4Title ?? '4. Provision of Personal Information to Third Parties'),
            _SectionContent(l10n?.privacySection4Content ?? ''),
            _SectionTitle(l10n?.privacySection5Title ?? '5. Personal Information Protection Measures'),
            _SectionContent(l10n?.privacySection5Content ?? ''),
            _SectionTitle(l10n?.privacySection6Title ?? '6. User Rights'),
            _SectionContent(l10n?.privacySection6Content ?? ''),
            _SectionTitle(l10n?.privacySection7Title ?? '7. Personal Information Protection Officer'),
            _SectionContent(l10n?.privacySection7Content ?? ''),
            _SectionTitle(l10n?.privacySection8Title ?? '8. Changes to Privacy Policy'),
            _SectionContent(l10n?.privacySection8Content ?? ''),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }
}