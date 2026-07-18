import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

class ProjectConnectionsSection extends ConsumerWidget {
  const ProjectConnectionsSection({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relationsAsync = ref.watch(projectRelationsProvider(projectId));
    final projectsAsync = ref.watch(homeProjectsProvider); // or custom provider
    final ideasAsync = ref.watch(allIdeasProvider);

    return relationsAsync.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold))),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Error loading connections: $err', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg)),
      ),
      data: (relations) {
        final allProjects = projectsAsync.valueOrNull ?? [];
        final allIdeas = ideasAsync.valueOrNull ?? [];

        final projectMap = {for (var p in allProjects) p.id: p};
        final ideaMap = {for (var i in allIdeas) i.id: i};

        if (relations.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDim.pad16),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(AppDim.radiusCard),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No active connections.',
                  style: AppText.body().copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                _AddConnectionButton(projectId: projectId),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppDim.radiusCard),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relations.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderDefault),
                itemBuilder: (context, index) {
                  final rel = relations[index];
                  final isFromCurrent = rel.fromId == projectId;
                  final otherId = isFromCurrent ? rel.toId : rel.fromId;
                  final otherType = isFromCurrent ? rel.toType : rel.fromType;

                  String otherName = 'Unknown Node';
                  bool isProject = otherType == 'project';
                  
                  if (isProject) {
                    otherName = projectMap[otherId]?.name ?? 'Project ($otherId)';
                  } else {
                    final idea = ideaMap[otherId];
                    if (idea != null) {
                      otherName = idea.content.length > 40
                          ? '${idea.content.substring(0, 38)}…'
                          : idea.content;
                    } else {
                      otherName = 'Idea ($otherId)';
                    }
                  }

                  // Explain the relationship in a human-friendly format
                  // depends_on | blocks | inspired_by | part_of | related_to
                  String relDesc = '';
                  if (isFromCurrent) {
                    relDesc = switch (rel.relationType) {
                      'depends_on'  => 'depends on',
                      'blocks'      => 'blocks',
                      'inspired_by' => 'inspired by',
                      'part_of'     => 'part of',
                      _             => 'related to',
                    };
                  } else {
                    relDesc = switch (rel.relationType) {
                      'depends_on'  => 'is required by',
                      'blocks'      => 'is blocked by',
                      'inspired_by' => 'inspired this',
                      'part_of'     => 'contains',
                      _             => 'related to',
                    };
                  }

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppDim.pad16, vertical: 4),
                    leading: Icon(
                      isProject ? Icons.account_tree_outlined : Icons.lightbulb_outline_rounded,
                      color: isProject ? AppColors.textSecondary : AppColors.gold,
                      size: 16,
                    ),
                    title: RichText(
                      text: TextSpan(
                        style: AppText.bodyWhite().copyWith(fontSize: 13),
                        children: [
                          TextSpan(
                            text: isFromCurrent ? 'This project ' : '$otherName ',
                            style: isFromCurrent ? null : const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '$relDesc ',
                            style: const TextStyle(color: AppColors.gold, fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: isFromCurrent ? otherName : 'this project',
                            style: isFromCurrent ? const TextStyle(fontWeight: FontWeight.bold) : null,
                          ),
                        ],
                      ),
                    ),
                    subtitle: rel.note != null && rel.note!.isNotEmpty
                        ? Text(rel.note!, style: AppText.body().copyWith(color: AppColors.textMuted, fontSize: 11))
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                      onPressed: () async {
                        await ref.read(relationDaoProvider).deleteRelation(rel.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Relationship removed')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      if (isProject) {
                        context.push('/project/$otherId');
                      } else {
                        context.push('/idea/$otherId');
                      }
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(AppDim.pad16),
                child: _AddConnectionButton(projectId: projectId),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddConnectionButton extends StatelessWidget {
  const _AddConnectionButton({required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderDefault),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusBtn),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _AddProjectRelationSheet(projectId: projectId),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Text('Add Connection', style: AppText.titleSmall()),
          ],
        ),
      ),
    );
  }
}

class _AddProjectRelationSheet extends ConsumerStatefulWidget {
  const _AddProjectRelationSheet({required this.projectId});
  final String projectId;

  @override
  ConsumerState<_AddProjectRelationSheet> createState() => _AddProjectRelationSheetState();
}

class _AddProjectRelationSheetState extends ConsumerState<_AddProjectRelationSheet> {
  String _targetType = 'project'; // project | idea
  String? _targetId;
  String _relationType = 'related_to';
  final _noteCtrl = TextEditingController();
  bool _saving = false;

  final _relationTypes = [
    'depends_on',
    'blocks',
    'inspired_by',
    'part_of',
    'related_to',
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final targetId = _targetId;
    if (targetId == null) return;

    setState(() => _saving = true);
    try {
      final dao = ref.read(relationDaoProvider);

      // Check duplicates
      final exists = await dao.relationExists(widget.projectId, targetId, _relationType);
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This relationship already exists')),
          );
        }
        return;
      }

      await dao.insertRelation(
        RelationsCompanion.insert(
          id: const Uuid().v4(),
          fromId: widget.projectId,
          fromType: 'project',
          toId: targetId,
          toType: _targetType,
          relationType: _relationType,
          note: Value(_noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()),
          createdAt: DateTime.now(),
        ),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(homeProjectsProvider).valueOrNull ?? [];
    final ideas = ref.watch(allIdeasProvider).valueOrNull ?? [];

    final projectOptions = projects.where((p) => p.id != widget.projectId).toList();
    final ideaOptions = ideas.where((i) => i.projectId != widget.projectId).toList();

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
      child: SingleChildScrollView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Connection', style: AppText.title()),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad12),

            // Tab selectors
            Row(
              children: [
                _tabButton('Project', 'project'),
                const SizedBox(width: AppDim.pad12),
                _tabButton('Idea', 'idea'),
              ],
            ),
            const SizedBox(height: AppDim.pad20),

            Text('SELECT TARGET ${_targetType.toUpperCase()}', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: AppDim.pad8),
            if (_targetType == 'project') ...[
              if (projectOptions.isEmpty)
                Text('No other projects available to connect.', style: AppText.body().copyWith(color: AppColors.textMuted))
              else
                _dropdown<String>(
                  value: _targetId,
                  hint: 'Choose a project...',
                  items: projectOptions.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name, style: AppText.bodyWhite()))).toList(),
                  onChanged: (val) => setState(() => _targetId = val),
                ),
            ] else ...[
              if (ideaOptions.isEmpty)
                Text('No other ideas available to connect.', style: AppText.body().copyWith(color: AppColors.textMuted))
              else
                _dropdown<String>(
                  value: _targetId,
                  hint: 'Choose an idea...',
                  items: ideaOptions.map((i) {
                    final truncated = i.content.length > 40 ? '${i.content.substring(0, 38)}…' : i.content;
                    return DropdownMenuItem(value: i.id, child: Text(truncated, style: AppText.bodyWhite(), overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) => setState(() => _targetId = val),
                ),
            ],
            const SizedBox(height: AppDim.pad20),

            Text('RELATION TYPE', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: AppDim.pad8),
            _dropdown<String>(
              value: _relationType,
              items: _relationTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').toUpperCase(), style: AppText.bodyWhite()))).toList(),
              onChanged: (val) => setState(() => _relationType = val ?? 'related_to'),
            ),
            const SizedBox(height: AppDim.pad20),

            Text('NOTE (OPTIONAL)', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: AppDim.pad8),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              style: AppText.bodyWhite(),
              decoration: InputDecoration(
                hintText: 'Add an optional note about this connection...',
                hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderDefault)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDim.radiusInput), borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5)),
                contentPadding: const EdgeInsets.all(AppDim.pad12),
              ),
            ),
            const SizedBox(height: AppDim.pad28),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDim.radiusBtn)),
                ),
                onPressed: _targetId == null || _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black)
                    : Text('Create Connection', style: AppText.titleSmall().copyWith(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, String type) {
    final active = _targetType == type;
    return GestureDetector(
      onTap: () => setState(() {
        _targetType = type;
        _targetId = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.gold.withValues(alpha: 0.1) : AppColors.surface1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.gold : AppColors.borderDefault),
        ),
        child: Text(
          label,
          style: AppText.body().copyWith(
            color: active ? AppColors.gold : AppColors.textSecondary,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _dropdown<T>({required T? value, String? hint, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(AppDim.radiusInput),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surface2,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          hint: hint != null ? Text(hint, style: AppText.body().copyWith(color: AppColors.textMuted)) : null,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
}
