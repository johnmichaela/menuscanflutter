// lib/language_settings_page.dart
import 'package:ballon/language_controller.dart';
import 'package:ballon/languages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ballon/l10n/app_strings.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<LanguageController>();
    final currentCode = controller.locale.languageCode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(context.tr.language),
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.titleMedium?.color),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ---------- Intro banner ----------
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
                    Icon(Icons.translate_outlined,
                        color: theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      context.tr.chooseLanguage,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'MenuScan will use your selection across all screens. '
                  'Arabic automatically switches the layout to right-to-left.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _SectionLabel(text: 'Available Languages'),
          const SizedBox(height: 8),

          // ---------- Language options ----------
          ...kSupportedLanguages.map((lang) {
            final selected = currentCode == lang.code;
            return _LanguageOption(
              language: lang,
              selected: selected,
              onTap: () => _onSelect(context, controller, lang),
            );
          }),

          const SizedBox(height: 24),

          // ---------- Info note ----------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    color: theme.colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Some menu content is provided by restaurants and may not '
                    'be available in every language yet.',
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------- Request a language ----------
          _SectionLabel(text: 'Missing your language?'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: navigate to feedback page
            },
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text('Request a Language'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: theme.primaryColor,
              side: BorderSide(color: theme.primaryColor.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelect(
    BuildContext context,
    LanguageController controller,
    AppLanguage lang,
  ) {
    controller.setLocale(lang.locale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${lang.englishName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ---------- Language option tile ----------

class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? theme.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    language.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 14),

                // Names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.nativeName,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (language.nativeName != language.englishName) ...[
                        const SizedBox(height: 2),
                        Text(
                          language.englishName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Check indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? theme.primaryColor : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? theme.primaryColor
                          : theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Section label ----------

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