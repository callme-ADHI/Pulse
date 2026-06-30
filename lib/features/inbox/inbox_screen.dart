import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../db/database.dart';

/// Inbox screen — §7.5
/// Reverse-chronological unsorted ideas.
/// Swipe right → link to project. Swipe left → archive.
/// Long-press → promote to new project.
class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ideasAsync = ref.watch(inboxIdeasProvider);

    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inbox', style: PulseTypography.displayMedium),
                  Text('Unsorted ideas', style: PulseTypography.bodySmall),
                ],
              ),
            ),
            Expanded(
              child: ideasAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent)),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (ideas) {
                  if (ideas.isEmpty) return _EmptyInbox();
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    itemCount: ideas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
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
      background: _SwipeBg(color: PulseColors.zoneActive, icon: Icons.link_rounded, alignment: Alignment.centerLeft, label: 'Link'),
      secondaryBackground: _SwipeBg(color: PulseColors.textTertiary, icon: Icons.archive_outlined, alignment: Alignment.centerRight, label: 'Archive'),
      onDismissed: (direction) async {
        final ideaDao = ref.read(ideaDaoProvider);
        if (direction == DismissDirection.startToEnd) {
          // Link to project
          _showProjectPicker(context, ref, idea);
        } else {
          await ideaDao.archiveIdea(idea.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Archived')),
            );
          }
        }
      },
      child: GestureDetector(
        onLongPress: () => _promoteToProject(context, ref, idea),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PulseColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PulseColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(idea.content, style: PulseTypography.bodyMedium),
              const SizedBox(height: 6),
              Text(_relTime(idea.createdAt), style: PulseTypography.bodySmall),
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
  const _SwipeBg({required this.color, required this.icon, required this.alignment, required this.label});
  final Color color;
  final IconData icon;
  final Alignment alignment;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label, style: PulseTypography.labelMedium.copyWith(color: color)),
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
      decoration: const BoxDecoration(color: PulseColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Center(child: Container(width: 36, height: 3, decoration: BoxDecoration(color: PulseColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Link to Project', style: PulseTypography.titleMedium),
          ),
          const SizedBox(height: 8),
          projectsAsync.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 1.5),
            error: (_, __) => const SizedBox(),
            data: (projects) => ListView.builder(
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(projects[i].name, style: PulseTypography.bodyMedium),
                onTap: () async {
                  await ref.read(ideaDaoProvider).linkIdeaToProject(idea.id, projects[i].id);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
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
      decoration: const BoxDecoration(color: PulseColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promote to Project', style: PulseTypography.titleMedium),
          const SizedBox(height: 8),
          Text(idea.content, style: PulseTypography.bodySmall.copyWith(color: PulseColors.textSecondary)),
          const SizedBox(height: 16),
          Text('This will create a new project and add an inspired_by relation back to this idea\'s source (if linked).', style: PulseTypography.bodySmall),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                context.pushNamed('newProject'); // TODO: pre-fill name from idea content
              },
              child: const Text('Create Project'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, color: PulseColors.textTertiary, size: 40),
            const SizedBox(height: 16),
            Text('Inbox is empty', style: PulseTypography.titleSmall),
            const SizedBox(height: 8),
            Text('Tap + to capture an idea. It will land here for sorting.', style: PulseTypography.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
