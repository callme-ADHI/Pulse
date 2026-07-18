import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Settings screen — §7.9
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _aiPromptTemplate = '''Generate a project plan in this exact YAML schema:

project:
  name: "Your Project Name"
  description: "What you're building"
  priority: medium              # low | medium | high
  startDate: "YYYY-MM-DD"       # Optional start date (ISO format)
  endDate: "YYYY-MM-DD"         # Optional deadline / end date (ISO format)
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('Settings', style: AppText.display().copyWith(fontSize: 26)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                children: [
                  _SettingsSection('IMPORT'),
                  _SettingsTile(
                    icon: Icons.upload_file_rounded,
                    title: 'Import YAML Plan',
                    subtitle: 'Paste AI-generated YAML to create a project',
                    onTap: () => context.push('/import'),
                  ),
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
                    icon: Icons.archive_rounded,
                    title: 'Project Archive',
                    subtitle: 'View completed, archived, and dropped projects',
                    onTap: () => context.pushNamed('archive'),
                  ),
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
      child: Text(label, style: AppText.label().copyWith(color: AppColors.textSecondary)),
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
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold, size: 20),
        title: Text(title, style: AppText.bodyWhite().copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppText.body()),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
