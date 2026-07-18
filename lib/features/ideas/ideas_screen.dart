import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

class IdeasScreen extends ConsumerStatefulWidget {
  const IdeasScreen({super.key});

  @override
  ConsumerState<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends ConsumerState<IdeasScreen> {
  String _activeFilter = 'all'; // all | unsorted | linked | archived
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  final _quickCaptureCtrl = TextEditingController();
  bool _savingIdea = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _quickCaptureCtrl.dispose();
    super.dispose();
  }

  Future<void> _quickCapture() async {
    final text = _quickCaptureCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _savingIdea = true);
    try {
      final id = const Uuid().v4();
      await ref.read(ideaDaoProvider).insertIdea(
        IdeasCompanion.insert(
          id: id,
          content: text,
          status: const Value('unsorted'),
          createdAt: DateTime.now(),
        ),
      );
      _quickCaptureCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Idea captured')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingIdea = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ideasAsync = ref.watch(allIdeasProvider);
    final projectsAsync = ref.watch(homeProjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IDEAS', style: AppText.display().copyWith(fontSize: 22)),
                  Text('CAPTURED INSPIRATION & BRAINSTORMS',
                      style: AppText.label().copyWith(color: AppColors.gold, letterSpacing: 2)),
                ],
              ),
            ),

            // Quick capture bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quickCaptureCtrl,
                      style: AppText.bodyWhite(),
                      decoration: InputDecoration(
                        hintText: 'Quick capture an idea...',
                        hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surface1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDim.radiusInput),
                          borderSide: const BorderSide(color: AppColors.borderDefault),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDim.radiusInput),
                          borderSide: const BorderSide(color: AppColors.borderDefault),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDim.radiusInput),
                          borderSide: const BorderSide(color: AppColors.borderStrong),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (_) => _quickCapture(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _quickCapture,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _savingIdea
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                            )
                          : const Icon(Icons.send_rounded, color: AppColors.gold, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: TextField(
                controller: _searchCtrl,
                style: AppText.bodyWhite(),
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search ideas...',
                  hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 18),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 16),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusInput),
                    borderSide: const BorderSide(color: AppColors.borderDefault),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusInput),
                    borderSide: const BorderSide(color: AppColors.borderDefault),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusInput),
                    borderSide: const BorderSide(color: AppColors.borderStrong),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('ALL', 'all'),
                    const SizedBox(width: 8),
                    _filterChip('UNSORTED', 'unsorted'),
                    const SizedBox(width: 8),
                    _filterChip('LINKED', 'linked'),
                    const SizedBox(width: 8),
                    _filterChip('ARCHIVED', 'archived'),
                  ],
                ),
              ),
            ),

            // Ideas list
            Expanded(
              child: ideasAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                ),
                error: (err, _) => Center(child: Text('Error: $err', style: AppText.body())),
                data: (ideas) {
                  final projects = projectsAsync.valueOrNull ?? [];
                  final projectMap = {for (var p in projects) p.id: p};

                  // Filter logic
                  var filtered = ideas.where((idea) {
                    // Filter tab
                    if (_activeFilter == 'unsorted') {
                      return idea.status == 'unsorted';
                    } else if (_activeFilter == 'linked') {
                      return idea.status == 'linked';
                    } else if (_activeFilter == 'archived') {
                      return idea.status == 'archived';
                    }
                    // 'all' includes unsorted and linked (exclude archived by default in 'all' view)
                    return idea.status != 'archived';
                  }).toList();

                  // Search logic
                  if (_searchQuery.isNotEmpty) {
                    filtered = filtered.where((idea) {
                      final contentMatch = idea.content.toLowerCase().contains(_searchQuery);
                      final descMatch = idea.description?.toLowerCase().contains(_searchQuery) ?? false;
                      return contentMatch || descMatch;
                    }).toList();
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isNotEmpty ? 'No search results.' : 'No ideas found.',
                        style: AppText.body().copyWith(color: AppColors.textMuted),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final idea = filtered[i];
                      final linkedProject = idea.projectId != null ? projectMap[idea.projectId] : null;

                      return _IdeaItemCard(
                        idea: idea,
                        project: linkedProject,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String filter) {
    final active = _activeFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.gold.withValues(alpha: 0.1) : AppColors.surface1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.gold : AppColors.borderDefault,
            width: active ? 1.2 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppText.label().copyWith(
            color: active ? AppColors.gold : AppColors.textSecondary,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _IdeaItemCard extends ConsumerWidget {
  const _IdeaItemCard({required this.idea, required this.project});
  final Idea idea;
  final Project? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasProject = project != null;

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
        icon: idea.status == 'archived' ? Icons.delete_forever_outlined : Icons.archive_outlined,
        alignment: Alignment.centerRight,
        label: idea.status == 'archived' ? 'DELETE' : 'ARCHIVE',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showProjectPicker(context, ref, idea);
          return false;
        } else {
          if (idea.status == 'archived') {
            await ref.read(ideaDaoProvider).deleteIdea(idea.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Idea deleted permanently')),
            );
          } else {
            await ref.read(ideaDaoProvider).archiveIdea(idea.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Idea archived')),
            );
          }
          return true;
        }
      },
      child: GestureDetector(
        onTap: () => context.push('/idea/${idea.id}'),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      idea.content,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (hasProject) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        project!.name.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (idea.description != null && idea.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  idea.description!,
                  style: AppText.body().copyWith(color: AppColors.textSecondary, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(idea.createdAt),
                    style: AppText.monoSmall().copyWith(color: AppColors.textMuted, fontSize: 10),
                  ),
                  Row(
                    children: [
                      if (hasProject)
                        GestureDetector(
                          onTap: () async {
                            await ref.read(ideaDaoProvider).updateIdea(
                              IdeasCompanion(
                                id: Value(idea.id),
                                projectId: const Value(null),
                                status: const Value('unsorted'),
                              ),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Unlinked from project')),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(
                              'UNLINK',
                              style: AppText.label().copyWith(color: AppColors.zoneCriticalFg, fontSize: 10),
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () => _showProjectPicker(context, ref, idea),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(
                              'LINK',
                              style: AppText.label().copyWith(color: AppColors.gold, fontSize: 10),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (idea.status == 'archived')
                        GestureDetector(
                          onTap: () async {
                            await ref.read(ideaDaoProvider).updateIdea(
                              IdeasCompanion(
                                id: Value(idea.id),
                                status: const Value('unsorted'),
                              ),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Idea restored to unsorted')),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(
                              'RESTORE',
                              style: AppText.label().copyWith(color: AppColors.textSecondary, fontSize: 10),
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () async {
                            await ref.read(ideaDaoProvider).archiveIdea(idea.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Idea archived')),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(
                              'ARCHIVE',
                              style: AppText.label().copyWith(color: AppColors.textMuted, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _showProjectPicker(BuildContext context, WidgetRef ref, Idea idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectPickerSheet(idea: idea),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDim.radiusCard),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppText.label().copyWith(color: color, fontWeight: FontWeight.bold)),
          ] else ...[
            Text(label, style: AppText.label().copyWith(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(icon, color: color, size: 20),
          ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Link Idea to Project', style: AppText.title()),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppDim.pad16),
          projectsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
            error: (err, _) => Text('Error loading projects: $err', style: AppText.body()),
            data: (projects) {
              if (projects.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('No active projects to link.', style: AppText.body().copyWith(color: AppColors.textMuted)),
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: projects.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderDefault),
                  itemBuilder: (context, index) {
                    final p = projects[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(p.name, style: AppText.bodyWhite()),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () async {
                        await ref.read(ideaDaoProvider).updateIdea(
                          IdeasCompanion(
                            id: Value(idea.id),
                            projectId: Value(p.id),
                            status: const Value('linked'),
                          ),
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Idea linked to "${p.name}"')),
                          );
                        }
                      },
                    );
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
