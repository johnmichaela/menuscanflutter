import 'package:ballon/screens/main/main_settings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ballon/l10n/app_strings.dart';
class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(context.tr.contactSupport),
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
                    Icon(Icons.headset_mic_outlined,
                        color: theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text( context.tr.weAreHereToHelp,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text( context.tr.contactSupportSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _SectionLabel(text: context.tr.reachUs),
          const SizedBox(height: 8),

          _ContactCard(
            icon: Icons.mail_outline,
            title: context.tr.emailSupport,
            subtitle: 'support@menuscan.com',
            trailing:  context.tr.emailSupportDesc,
            onTap: () => _launch('mailto:support@menuscan.com'),
          ),
          _ContactCard(
            icon: Icons.bug_report_outlined,
            title: context.tr.reportBug,
            subtitle: 'bugs@menuscan.com',
            trailing:  context.tr.reportBugDesc,
            onTap: () => _launch('mailto:bugs@menuscan.com'),
          ),
          _ContactCard(
            icon: Icons.privacy_tip_outlined,
            title: context.tr.privacyInquiries,
            subtitle: 'privacy@menuscan.com',
            trailing:  context.tr.privacyInquiriesDesc,
            onTap: () => _launch('mailto:privacy@menuscan.com'),
          ),
          _ContactCard(
            icon: Icons.gavel_outlined,
            title: context.tr.legal,
            subtitle: 'legal@menuscan.com',
            trailing:  context.tr.legalDesc,
            onTap: () => _launch('mailto:legal@menuscan.com'),
          ),

          const SizedBox(height: 24),

          _SectionLabel(text:context.tr.beforeYouWrite),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( context.tr.includeTheseDetails,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _Bullet(text: context.tr.yourAccountEmail),
                _Bullet(text: context.tr.appVersion),
                _Bullet(text: context.tr.deviceAndOs),
                _Bullet(text: context.tr.stepsToReproduce),
                _Bullet(text:context.tr.screenshots),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _SectionLabel(text:  context.tr.responseTimes),
          const SizedBox(height: 8),

          _InfoRow(label: context.tr.generalInquiries, value: '1–2 business days'),
          _InfoRow(label: context.tr.bugReports, value: '24–48 hours'),
          _InfoRow(label: context.tr.privacyRequests, value: 'Up to 7 days'),
          _InfoRow(label: context.tr.criticalIssues, value: 'Same day (business hours)'),

          const SizedBox(height: 24),

          _SectionLabel(text: context.tr.followUs),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: Icons.public,
                  label: context.tr.website,
                  onTap: () => _launch('https://menuscan.com'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Icons.alternate_email,
                  label: 'X',
                  onTap: () => _launch('https://twitter.com/menuscan'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  onTap: () => _launch('https://instagram.com/menuscan'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // CTA — Send Feedback
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeedbackPage()),
                );
              },
              icon: const Icon(Icons.rate_review_outlined),
              label:  Text(context.tr.sendInAppFeedback
                ,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text( context.tr.weReadEveryMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Helpers ----------

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.primaryColor.withOpacity(0.15),
                child: Icon(icon, color: theme.primaryColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trailing,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        foregroundColor: theme.primaryColor,
        side: BorderSide(color: theme.primaryColor.withOpacity(0.4)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}