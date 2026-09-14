import 'package:flutter/material.dart';
import 'package:ballon/l10n/app_strings.dart';
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(context.tr.privacyPolicy),
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.titleMedium?.color),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Header banner
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
                    Icon(Icons.shield_outlined,
                        color: theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text( context.tr.yourPrivacyMatters
                     ,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text( context.tr.privacyIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 8),
                Text( context.tr.lastUpdated,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _PolicySection(
            number: '1' ,
            title: context.tr.informationWeCollect,
            body:context.tr.informationWeCollectBody
                ,
          ),

          _PolicySection(
            number: '2',
            title:  context.tr.howWeUseYourData,
            body:context.tr.howWeUseYourDataBody
               
          ),

          _PolicySection(
            number: '3',
            title: context.tr.sharingThirdParties,
            body:context.tr.sharingThirdPartiesBody
               ,
          ),

          _PolicySection(
            number: '4',
            title:  context.tr.dataRetention,
            body:context.tr.dataRetentionBody
               
          ),

          _PolicySection(
            number: '5',
            title: context.tr.yourRights,
            body:context.tr.yourRightsBody
                
          ),

          _PolicySection(
            number: '6',
            title:  context.tr.cookiesTracking,
            body:context.tr.cookiesTrackingBody
             
          ),

          _PolicySection(
            number: '7',
            title: context.tr.childrensPrivacy,
            body:context.tr.childrensPrivacyBody
              
          ),

          _PolicySection(
            number: '8',
            title:  context.tr.changesToThisPolicy,
            body:context.tr.changesToThisPolicyBody
                
          ),

          _PolicySection(
            number: '9',
            title:  context.tr.contactUs,
            body:context.tr.contactUsBody
                
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

// Shared section widget (used by all three pages)
class _PolicySection extends StatelessWidget {
  final String number;
  final String title;
  final String body;

  const _PolicySection({
    required this.number,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}