import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// Full-screen idea detail — shows content, description, metadata
/// and lets the user edit, link to a project, or promote to a project.
class IdeaDetailScreen extends ConsumerStatefulWidget {
  const IdeaDetailScreen({super.key, required this.ideaId});
  final String ideaId;

  @override
  ConsumerState<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends ConsumerState<IdeaDetailScreen> {
  bool _editing = false;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _contentCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(Idea idea) async {
    if (_contentCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(ideaDaoProvider).updateIdea(
        IdeasCompanion(
          id: Value(idea.id),
          content: Value(_contentCtrl.text.trim()),
          description: Value(
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          ),
        ),
      );
      setState(() => _editing = false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _startEditing(Idea idea) {
    _contentCtrl.text = idea.content;
    _descCtrl.text = idea.description ?? '';
    setState(() => _editing = true);
  }

  void _showLinkSheet(BuildContext context, Idea idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LinkToProjectSheet(idea: idea),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ideaAsync = ref.watch(ideaByIdProvider(widget.ideaId));

    return ideaAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $e', style: AppText.body())),
      ),
      data: (idea) {
        if (idea == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Idea not found', style: AppText.body())),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              idea.status == 'unsorted' ? 'INBOX IDEA' : 'IDEA',
              style: AppText.label().copyWith(letterSpacing: 1.5),
            ),
            actions: [
              if (!_editing) ...[
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: AppColors.textSecondary, size: 20),
                  onPressed: () => _startEditing(idea),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 20),
                  color: AppColors.surface2,
                  onSelected: (v) async {
                    if (v == 'link') {
                      _showLinkSheet(context, idea);
                    } else if (v == 'promote') {
                      if (context.mounted) {
                        context.push(
                          '/new-project?name=${Uri.encodeComponent(idea.content.split('\n').first)}&desc=${Uri.encodeComponent(idea.content)}&ideaId=${idea.id}',
                        );
                      }
                    } else if (v == 'archive') {
                      await ref.read(ideaDaoProvider).archiveIdea(idea.id);
                      if (context.mounted) context.pop();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'link',
                      child: Row(children: [
                        Icon(Icons.link_rounded, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 10),
                        Text('Link to Project'),
                      ]),
                    ),
                    const PopupMenuItem(
                      value: 'promote',
                      child: Row(children: [
                        Icon(Icons.rocket_launch_rounded, size: 16, color: AppColors.gold),
                        SizedBox(width: 10),
                        Text('Promote to Project', style: TextStyle(color: AppColors.gold)),
                      ]),
                    ),
                    const PopupMenuItem(
                      value: 'archive',
                      child: Row(children: [
                        Icon(Icons.archive_outlined, size: 16, color: AppColors.zoneCriticalFg),
                        SizedBox(width: 10),
                        Text('Archive', style: TextStyle(color: AppColors.zoneCriticalFg)),
                      ]),
                    ),
                  ],
                ),
              ] else ...[
                if (_saving)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold))),
                  )
                else ...[
                  TextButton(
                    onPressed: () => setState(() => _editing = false),
                    child: Text('Cancel', style: AppText.body()),
                  ),
                  TextButton(
                    onPressed: () => _save(idea),
                    child: Text('Save', style: AppText.body().copyWith(color: AppColors.gold)),
                  ),
                ],
              ],
            ],
          ),
          body: _editing ? _EditBody(contentCtrl: _contentCtrl, descCtrl: _descCtrl) : _ViewBody(idea: idea),
        );
      },
    );
  }
}

// ─── View Mode ───────────────────────────────────────────────────────────────

class _ViewBody extends StatelessWidget {
  const _ViewBody({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy • HH:mm');

    return ListView(
      padding: const EdgeInsets.all(AppDim.pad20),
      children: [
        // Status chip
        Row(
          children: [
            _StatusChip(status: idea.status),
            if (idea.projectId != null) ...[
              const SizedBox(width: 8),
              _LinkedProjectChip(projectId: idea.projectId!),
            ],
          ],
        ),
        const SizedBox(height: 20),

        // Content
        Text(
          idea.content,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Description
        if (idea.description != null && idea.description!.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDim.pad16),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(AppDim.radiusCard),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Text(
              idea.description!,
              style: AppText.body().copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Metadata
        Container(
          padding: const EdgeInsets.all(AppDim.pad16),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppDim.radiusCard),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            children: [
              _MetaRow('Created', fmt.format(idea.createdAt)),
              const SizedBox(height: 8),
              _MetaRow('Status', idea.status),
              if (idea.sourceImportId != null) ...[
                const SizedBox(height: 8),
                _MetaRow('From import', idea.sourceImportId!.substring(0, 8)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 90,
        child: Text(label, style: AppText.label().copyWith(color: AppColors.textMuted)),
      ),
      Expanded(child: Text(value, style: AppText.monoSmall())),
    ],
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'linked'   => AppColors.zoneActiveFg,
      'promoted' => AppColors.gold,
      'archived' => AppColors.textMuted,
      _          => AppColors.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppText.label().copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

class _LinkedProjectChip extends ConsumerWidget {
  const _LinkedProjectChip({required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));
    return projectAsync.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (project) {
        if (project == null) return const SizedBox();
        return GestureDetector(
          onTap: () => context.push('/project/$projectId'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link_rounded, size: 12, color: AppColors.gold),
                const SizedBox(width: 4),
                Text(
                  project.name,
                  style: AppText.label().copyWith(color: AppColors.gold, fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Edit Mode ───────────────────────────────────────────────────────────────

class _EditBody extends StatelessWidget {
  const _EditBody({required this.contentCtrl, required this.descCtrl});
  final TextEditingController contentCtrl;
  final TextEditingController descCtrl;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDim.pad20),
      children: [
        Text('IDEA', style: AppText.label().copyWith(color: AppColors.textMuted)),
        const SizedBox(height: AppDim.pad8),
        TextField(
          controller: contentCtrl,
          autofocus: true,
          maxLines: null,
          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.5),
          decoration: InputDecoration(
            hintText: 'What\'s the idea?',
            hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface1,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5)),
            contentPadding: const EdgeInsets.all(AppDim.pad12),
          ),
        ),
        const SizedBox(height: AppDim.pad16),
        Text('DESCRIPTION (OPTIONAL)', style: AppText.label().copyWith(color: AppColors.textMuted)),
        const SizedBox(height: AppDim.pad8),
        TextField(
          controller: descCtrl,
          maxLines: 6,
          style: AppText.body().copyWith(color: AppColors.textSecondary, height: 1.6),
          decoration: InputDecoration(
            hintText: 'Add more context, research notes, or details…',
            hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface1,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5)),
            contentPadding: const EdgeInsets.all(AppDim.pad12),
          ),
        ),
      ],
    );
  }
}

// ─── Link to Project Sheet ───────────────────────────────────────────────────

class _LinkToProjectSheet extends ConsumerWidget {
  const _LinkToProjectSheet({required this.idea});
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
              width: 36, height: 3,
              decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppDim.pad16),
          Text('Link to Project', style: AppText.title()),
          const SizedBox(height: AppDim.pad12),
          projectsAsync.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold))),
            error: (e, _) => Text('Error loading projects', style: AppText.body()),
            data: (projects) {
              final active = projects.where((p) => p.status != 'archived' && p.status != 'dropped').toList();
              if (active.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('No active projects found.', style: AppText.body().copyWith(color: AppColors.textMuted)),
                );
              }
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: active.length,
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(active[i].name, style: AppText.bodyWhite()),
                    subtitle: Text(active[i].status, style: AppText.label().copyWith(color: AppColors.textMuted)),
                    trailing: idea.projectId == active[i].id
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 18)
                        : const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () async {
                      await ref.read(ideaDaoProvider).linkIdeaToProject(idea.id, active[i].id);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
