import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Settings screen — §7.9
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _aiPromptTemplate = '''Generate a project plan in this exact YAML schema:

project:
  name: "Your Project Name"
  description: "What you're building"
  priority: medium              # low | medium | high
  phases:
    - name: "Phase name"
      summary: "High-level milestone"
  ideas:
    - "An idea or open question"
  relations:
    - to: "Another Project"
      type: related_to          # depends_on | blocks | inspired_by | part_of | related_to
      note: "Why they're connected"

Project: [describe your project here]

Keep phases to 3–6 high-level milestones. No task-level detail. No checkboxes. Phases are descriptive only.''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('Settings', style: PulseTypography.displayMedium),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                children: [
                  _SettingsSection('IMPORT'),
                  _SettingsTile(
                    icon: Icons.history_rounded,
                    title: 'Import History',
                    subtitle: 'View and revert past YAML imports',
                    onTap: () => context.pushNamed('importHistory'),
                  ),
                  _SettingsTile(
                    icon: Icons.copy_rounded,
                    title: 'Copy AI Prompt Template',
                    subtitle: 'Ready-made prompt to generate a compatible YAML plan',
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: _aiPromptTemplate));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AI prompt template copied to clipboard')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _SettingsSection('DATA'),
                  _SettingsTile(
                    icon: Icons.download_rounded,
                    title: 'Export All Data',
                    subtitle: 'Download full JSON backup of every table',
                    onTap: () {}, // Phase 5
                  ),
                  const SizedBox(height: 20),
                  _SettingsSection('NOTIFICATIONS'),
                  _SettingsTile(
                    icon: Icons.do_not_disturb_on_rounded,
                    title: 'Quiet Hours',
                    subtitle: '22:00 — 08:00 (no notifications)',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _SettingsSection('ABOUT'),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Pulse by AEVORAX',
                    subtitle: 'v1.0.0 — local-only, offline-first',
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Pulse',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 AEVORAX\nBuilt for momentum, not management.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(label, style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PulseColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: PulseColors.accent, size: 20),
        title: Text(title, style: PulseTypography.bodyMedium),
        subtitle: Text(subtitle, style: PulseTypography.bodySmall),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
