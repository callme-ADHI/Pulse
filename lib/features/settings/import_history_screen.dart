import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Import History', style: AppText.title()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: importsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
        error: (e, _) => Center(child: Text('Error: $e', style: AppText.body())),
        data: (imports) {
          if (imports.isEmpty) {
            return Center(child: Text('No imports yet', style: AppText.body().copyWith(color: AppColors.textMuted)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: imports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: import.isReverted
              ? AppColors.textMuted.withValues(alpha: 0.3)
              : AppColors.borderDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(date, style: AppText.label().copyWith(color: AppColors.textMuted))),
              if (import.isReverted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(4)),
                  child: Text('REVERTED', style: AppText.label().copyWith(color: AppColors.textMuted)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(import.summary, style: AppText.bodyWhite().copyWith(fontWeight: FontWeight.w500)),
          if (import.parseWarnings != null) ...[
            const SizedBox(height: 6),
            Text(import.parseWarnings!, style: AppText.body().copyWith(color: AppColors.zoneDriftingFg), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (!import.isReverted) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _revert(context, ref, import.id),
              icon: const Icon(Icons.undo_rounded, size: 16),
              label: const Text('Revert'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.zoneCriticalFg,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _revert(BuildContext context, WidgetRef ref, String importId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: Text('Revert Import', style: AppText.title()),
        content: Text('This will soft-delete all projects, ideas, and relations created by this import. Continue?', style: AppText.body()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: AppText.body())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.zoneCriticalFg),
            child: Text('Revert', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg, fontWeight: FontWeight.bold)),
          ),
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
      for (final p in projects) {
        await projectDao.softDeleteProject(p.id);
      }
      final ideas = await ideaDao.getIdeasBySourceImport(importId);
      for (final i in ideas) {
        await ideaDao.archiveIdea(i.id);
      }
      await relationDao.softDeleteRelationsBySourceImport(importId);
      await yamlImportDao.markReverted(importId);
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import reverted')));
    }
  }
}
