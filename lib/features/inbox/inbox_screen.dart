import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// Inbox screen — spec §6.5 / §7.5
/// Shows unsorted captured ideas.
/// Swipe right → link to project.
/// Swipe left → archive.
/// Tap → edit/promote detail sheet.
class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ideasAsync = ref.watch(inboxIdeasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inbox', style: AppText.title()),
                  const SizedBox(height: 2),
                  Text('Swipe to link / archive. Tap to edit and promote.',
                      style: AppText.label().copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Expanded(
              child: ideasAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                ),
                error: (e, _) => Center(child: Text('Error: $e', style: AppText.body())),
                data: (ideas) {
                  if (ideas.isEmpty) return const _EmptyInbox();
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    itemCount: ideas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _IdeaTile(idea: ideas[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdeaTile extends ConsumerWidget {
  const _IdeaTile({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(idea.id),
      background: _SwipeBg(
        color: AppColors.zoneActiveFg,
        icon: Icons.link_rounded,
        alignment: Alignment.centerLeft,
        label: 'LINK',
      ),
      secondaryBackground: _SwipeBg(
        color: AppColors.zoneCriticalFg,
        icon: Icons.archive_outlined,
        alignment: Alignment.centerRight,
        label: 'ARCHIVE',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showProjectPicker(context, ref, idea);
          return false; // picker handles DB mutation and pops/closes sheet
        } else {
          await ref.read(ideaDaoProvider).archiveIdea(idea.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Idea archived')),
          );
          return true;
        }
      },
      child: GestureDetector(
        onTap: () => context.push('/idea/${idea.id}'),
        onLongPress: () => _promoteToProject(context, ref, idea),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDim.cardPad),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppDim.radiusCard),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                idea.content,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              if (idea.description != null && idea.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  idea.description!,
                  style: AppText.body().copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                _relTime(idea.createdAt),
                style: AppText.monoSmall().copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  void _showProjectPicker(BuildContext context, WidgetRef ref, Idea idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectPickerSheet(idea: idea),
    );
  }

  void _promoteToProject(BuildContext context, WidgetRef ref, Idea idea) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PromoteSheet(idea: idea),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  const _SwipeBg({
    required this.color,
    required this.icon,
    required this.alignment,
    required this.label,
  });
  final Color color;
  final IconData icon;
  final Alignment alignment;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDim.radiusCard),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.0,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: color, size: 16),
          ]
        ],
      ),
    );
  }
}

class _ProjectPickerSheet extends ConsumerWidget {
  const _ProjectPickerSheet({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(homeProjectsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDim.pad20,
        AppDim.pad16,
        AppDim.pad20,
        MediaQuery.of(context).viewInsets.bottom + AppDim.pad28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDim.pad16),
          Text('Link to Project', style: AppText.title()),
          const SizedBox(height: AppDim.pad12),
          projectsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
              ),
            ),
            error: (e, _) => Text('Error loading projects', style: AppText.body()),
            data: (projects) {
              final active = projects.where((p) => p.status != 'archived').toList();
              if (active.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('No active projects found.',
                      style: AppText.body().copyWith(color: AppColors.textMuted)),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: active.length,
                itemBuilder: (_, i) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(active[i].name, style: AppText.bodyWhite()),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () async {
                    await ref.read(ideaDaoProvider).linkIdeaToProject(idea.id, active[i].id);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PromoteSheet extends ConsumerWidget {
  const _PromoteSheet({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: const EdgeInsets.all(AppDim.pad20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promote to Project', style: AppText.title()),
          const SizedBox(height: 8),
          Text(
            idea.content,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'This will promote this idea into a fully-fledged active project.',
            style: AppText.body().copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/new-project?name=${Uri.encodeComponent(idea.content.split('\n').first)}&desc=${Uri.encodeComponent(idea.content)}&ideaId=${idea.id}');
              },
              child: Text(
                'Promote Now',
                style: AppText.titleSmall().copyWith(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, color: AppColors.textMuted, size: 40),
            const SizedBox(height: 16),
            Text('Inbox is empty', style: AppText.titleSmall()),
            const SizedBox(height: 8),
            Text(
              'Capture raw ideas using the + button at the bottom. Link them to projects or promote them to project status here.',
              style: AppText.body().copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
