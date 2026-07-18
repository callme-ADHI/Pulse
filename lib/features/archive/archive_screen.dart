import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../db/database.dart';
import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

final archivedAndDroppedProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(projectDaoProvider).watchArchivedAndDropped();
});

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  String _selectedFilter = 'ALL'; // ALL | COMPLETED | ARCHIVED | DROPPED

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(archivedAndDroppedProjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      Text('ARCHIVE', style: AppText.display().copyWith(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      'COMPLETED, ARCHIVED & DROPPED PROJECTS',
                      style: AppText.label().copyWith(color: AppColors.textSecondary, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // Filter pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: ['ALL', 'COMPLETED', 'ARCHIVED', 'DROPPED'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: AppText.label().copyWith(
                          color: isSelected ? AppColors.background : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      backgroundColor: AppColors.surface1,
                      disabledColor: AppColors.surface1,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? AppColors.gold : AppColors.borderDefault,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Project List
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading debris: $err', style: AppText.body()),
                ),
                data: (projects) {
                  final filtered = projects.where((p) {
                    if (_selectedFilter == 'ALL') return true;
                    return p.status.toUpperCase() == _selectedFilter;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'NO RECORDED DEBRIS',
                        style: AppText.monoSmall().copyWith(color: AppColors.textMuted, letterSpacing: 2),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ArchiveProjectCard(
                          project: p,
                          onRestore: () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            await ref.read(projectDaoProvider).restore(p.id);
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text('Restored "${p.name}" to Active status.'),
                                backgroundColor: AppColors.surface3,
                              ),
                            );
                          },
                        ),
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
}

class _ArchiveProjectCard extends StatelessWidget {
  const _ArchiveProjectCard({
    required this.project,
    required this.onRestore,
  });

  final Project project;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.statusColor(project.status);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(AppDim.radiusCard),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
          onTap: () => context.push('/project/${project.id}'),
          child: Padding(
            padding: const EdgeInsets.all(AppDim.cardPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(project.name, style: AppText.title()),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: statusColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              project.status.toUpperCase(),
                              style: AppText.label().copyWith(
                                color: statusColor,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                      color: AppColors.surface2,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.borderDefault),
                      ),
                      onSelected: (val) {
                        if (val == 'restore') {
                          onRestore();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'restore',
                          child: Row(
                            children: [
                              const Icon(Icons.settings_backup_restore_rounded, color: AppColors.gold, size: 18),
                              const SizedBox(width: 8),
                              Text('Restore to Active', style: AppText.bodyWhite()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (project.status == 'dropped' && project.dropReason != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.zoneCriticalBg.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.zoneCriticalFg.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DROP REASON:',
                          style: AppText.label().copyWith(color: AppColors.zoneCriticalFg, fontSize: 8),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${project.dropReason}"',
                          style: AppText.body().copyWith(
                            color: AppColors.textPrimary,
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (project.description != null && project.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    project.description!,
                    style: AppText.body().copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
