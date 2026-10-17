import 'package:ballon/screens/sub/contact.dart';
import 'package:ballon/screens/sub/privacypolicy.dart';
import 'package:ballon/screens/sub/termsofservice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ballon/l10n/app_strings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(context.tr.about),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // App Logo
            Image.asset('assets/img/splash.png',color: Theme.of(context).primaryColor,),
            // Container(
            //   width: 120,
            //   height: 120,
            //   decoration: BoxDecoration(
            //     color: theme.colorScheme.primaryContainer,
            //     borderRadius: BorderRadius.circular(28),
            //     boxShadow: [
            //       BoxShadow(
            //         color: theme.colorScheme.primary.withOpacity(0.3),
            //         blurRadius: 20,
            //         offset: const Offset(0, 8),
            //       ),
            //     ],
            //   ),
            //   child: Icon(
            //     Icons.qr_code_scanner_rounded,
            //     size: 64,
            //     color: theme.colorScheme.primary,
            //   ),
            // ),
            // const SizedBox(height: 20),

            // // App Name
            // Text(
            //   'MenuScan',
            //   style: theme.textTheme.headlineMedium?.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 4),

            // Version
            Text( context.tr.version
              ,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Description Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child:  Padding(
                padding: EdgeInsets.all(16),
                child: Text( 
                  'MenuScan lets you instantly scan restaurant QR codes '
                  'to view digital menus, discover dishes, and see prices — '
                  'no app downloads or waiting required.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info tiles
            _InfoTile(
              icon: Icons.restaurant_menu,
              title:  context.tr.digitalMenus,
              subtitle: context.tr.digitalMenusSubtitle,
            ),
            _InfoTile(
              icon: Icons.qr_code_2,
              title:  context.tr.fastScanning,
              subtitle: context.tr.fastScanningSubtitle,
            ),
            // _InfoTile(
            //   icon: Icons.favorite_border,
            //   title: 'Save Favorites',
            //   subtitle: 'Bookmark your favorite dishes',
            // ),
             _InfoTile(
                icon: Icons.event_available,
                title:context.tr.savedEvents,
                subtitle: context.tr.savedEventsSubtitle,
              ),
            _InfoTile(
              icon: Icons.share_outlined,
              title: context.tr.shareMenus,
              subtitle: context.tr.shareMenusSubtitle,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Links
            _LinkTile(
              icon: Icons.star_outline,
              title:  context.tr.rateUs,
              onTap: () => _launchUrl('https://play.google.com/store'),
            ),
            _LinkTile(
              icon: Icons.privacy_tip_outlined,
              title: context.tr.privacyPolicy,
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage())),
            ),
            _LinkTile(
              icon: Icons.description_outlined,
              title: context.tr.termsOfService,
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServicePage())),
            ),
            _LinkTile(
              icon: Icons.mail_outline,
              title: context.tr.contactSupport,
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactSupportPage())),
            ),

            const SizedBox(height: 32),

            // Footer
            Text( context.tr.madeWithLoveBy,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(context.tr.allRightsReserved,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// --- Reusable Widgets ---

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}