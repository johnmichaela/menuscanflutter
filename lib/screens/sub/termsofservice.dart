import 'package:flutter/material.dart';
import 'package:ballon/l10n/app_strings.dart';
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(context.tr.termsOfService),
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.titleMedium?.color),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.primaryColor.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gavel_outlined,
                        color: theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text( context.tr.rulesOfUsing,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text( context.tr.termsIntro
                 ,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr.effective,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _TermsSection(
            title: context.tr.acceptanceOfTerms,
            body:context.tr.acceptanceOfTermsBody
                ,
          ),
          _TermsSection(
            title:  context.tr.yourAccount,
            body:context.tr.yourAccountBody
                ,
          ),
          _TermsSection(
            title: context.tr.acceptableUse,
            body:context.tr.acceptableUseBody
               ,
          ),
          _TermsSection(
            title: context.tr.menuContent,
            body:context.tr.menuContentBody
               ,
          ),
          _TermsSection(
            title: context.tr.intellectualProperty,
            body:context.tr.intellectualPropertyBody
                ,
          ),
          _TermsSection(
            title:  context.tr.serviceAvailability,
            body:context.tr.serviceAvailabilityBody
               ,
          ),
          _TermsSection(
            title:  context.tr.limitationOfLiability,
            body:context.tr.limitationOfLiabilityBody,
          ),
          _TermsSection(
            title: context.tr.termination,
            body:context.tr.terminationBody
              ,
          ),
          _TermsSection(
            title: context.tr.changesToTerms,
            body:context.tr.changesToTermsBody
              ,
          ),
          _TermsSection(
            title:  context.tr.contact,
            body:context.tr.contactBody
                
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '© 2025 MenuScan. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String body;

  const _TermsSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}