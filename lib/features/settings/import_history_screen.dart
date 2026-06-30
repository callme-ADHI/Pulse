import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../db/database.dart';
import 'package:intl/intl.dart';

/// Import History screen — §4.5 Step 5
/// Reverse-chronological list with Revert per import.
class ImportHistoryScreen extends ConsumerWidget {
  const ImportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importsAsync = ref.watch(yamlImportHistoryProvider);

    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: const Text('Import History'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: importsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (imports) {
          if (imports.isEmpty) {
            return Center(child: Text('No imports yet', style: PulseTypography.bodySmall));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: imports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _ImportRow(import: imports[i]),
          );
        },
      ),
    );
  }
}

class _ImportRow extends ConsumerWidget {
  const _ImportRow({required this.import});
  final YamlImport import;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('MMM d, y — HH:mm').format(import.importedAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: import.isReverted ? PulseColors.textTertiary.withOpacity(0.3) : PulseColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(date, style: PulseTypography.bodySmall.copyWith(color: PulseColors.textTertiary))),
              if (import.isReverted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: PulseColors.surfaceElevated, borderRadius: BorderRadius.circular(4)),
                  child: Text('REVERTED', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(import.summary, style: PulseTypography.bodyMedium),
          if (import.parseWarnings != null) ...[
            const SizedBox(height: 6),
            Text(import.parseWarnings!, style: PulseTypography.bodySmall.copyWith(color: PulseColors.warning), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (!import.isReverted) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _revert(context, ref, import.id),
              icon: const Icon(Icons.undo_rounded, size: 16),
              label: const Text('Revert'),
              style: TextButton.styleFrom(foregroundColor: PulseColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _revert(BuildContext context, WidgetRef ref, String importId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Revert Import'),
        content: const Text('This will soft-delete all projects, ideas, and relations created by this import. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: PulseColors.error), child: const Text('Revert')),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final db = ref.read(databaseProvider);
    final projectDao = ref.read(projectDaoProvider);
    final ideaDao = ref.read(ideaDaoProvider);
    final relationDao = ref.read(relationDaoProvider);
    final yamlImportDao = ref.read(yamlImportDaoProvider);

    await db.transaction(() async {
      final projects = await projectDao.getProjectsBySourceImport(importId);
      for (final p in projects) await projectDao.softDeleteProject(p.id);
      await ideaDao.getIdeasBySourceImport(importId);
      // Archive ideas from this import
      final ideas = await ideaDao.getIdeasBySourceImport(importId);
      for (final i in ideas) await ideaDao.archiveIdea(i.id);
      await relationDao.softDeleteRelationsBySourceImport(importId);
      await yamlImportDao.markReverted(importId);
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import reverted')));
    }
  }
}
