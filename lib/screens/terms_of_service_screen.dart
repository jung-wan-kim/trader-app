import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.termsOfService ?? 'Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.termsTitle ?? 'Trader App Terms of Service',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              l10n?.termsEffectiveDate ?? 'Effective Date: February 21, 2025',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            _SectionTitle(l10n?.termsSection1Title ?? 'Article 1 (Purpose)'),
            _SectionContent(l10n?.termsSection1Content ?? ''),
            _SectionTitle(l10n?.termsSection2Title ?? 'Article 2 (Definitions)'),
            _SectionContent(l10n?.termsSection2Content ?? ''),
            _SectionTitle(l10n?.termsSection3Title ?? 'Article 3 (Effectiveness and Changes to Terms)'),
            _SectionContent(l10n?.termsSection3Content ?? ''),
            _SectionTitle(l10n?.termsSection4Title ?? 'Article 4 (Provision of Services)'),
            _SectionContent(l10n?.termsSection4Content ?? ''),
            _FinancialDisclaimer(l10n: l10n),
            _SectionTitle(l10n?.termsSection5Title ?? 'Article 5 (Membership Registration)'),
            _SectionContent(l10n?.termsSection5Content ?? ''),
            _SectionTitle(l10n?.termsSection6Title ?? 'Article 6 (User Obligations)'),
            _SectionContent(l10n?.termsSection6Content ?? ''),
            _SectionTitle(l10n?.termsSection7Title ?? 'Article 7 (Service Usage Fees)'),
            _SectionContent(l10n?.termsSection7Content ?? ''),
            _SectionTitle(l10n?.termsSection8Title ?? 'Article 8 (Disclaimer)'),
            _SectionContent(l10n?.termsSection8Content ?? ''),
            _SectionTitle(l10n?.termsSection9Title ?? 'Article 9 (Privacy Protection)'),
            _SectionContent(l10n?.termsSection9Content ?? ''),
            _SectionTitle(l10n?.termsSection10Title ?? 'Article 10 (Dispute Resolution)'),
            _SectionContent(l10n?.termsSection10Content ?? ''),
            SizedBox(height: 40),
            Text(
              l10n?.termsSupplementary ?? 'Supplementary Provisions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              l10n?.termsSupplementaryDate ?? 'These terms are effective from February 21, 2025.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 40),
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

class _FinancialDisclaimer extends StatelessWidget {
  final AppLocalizations? l10n;
  const _FinancialDisclaimer({this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                l10n?.investmentWarningTitle ?? 'Investment Risk Warning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            l10n?.termsFinancialDisclaimer ?? '',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}