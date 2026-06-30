import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'yaml_parser.dart';
import '../../db/database.dart';
import 'package:uuid/uuid.dart';

/// Import Preview screen — §4.5 Steps 3–4
/// Shows "Will create" / "Will link" / "Warnings" grouped list.
/// Cancel = zero side effects. Confirm = single Drift transaction.
class ImportPreviewScreen extends ConsumerStatefulWidget {
  const ImportPreviewScreen({super.key, required this.rawYaml, required this.parseResult});
  final String rawYaml;
  final YamlParseResult parseResult;

  @override
  ConsumerState<ImportPreviewScreen> createState() => _ImportPreviewScreenState();
}

class _ImportPreviewScreenState extends ConsumerState<ImportPreviewScreen> {
  bool _committing = false;

  Future<void> _commit() async {
    setState(() => _committing = true);
    const uuid = Uuid();
    final db = ref.read(databaseProvider);
    final projectDao = ref.read(projectDaoProvider);
    final ideaDao = ref.read(ideaDaoProvider);
    final relationDao = ref.read(relationDaoProvider);
    final yamlImportDao = ref.read(yamlImportDaoProvider);

    try {
      final importId = uuid.v4();
      int createdProjects = 0, createdIdeas = 0, createdRelations = 0;
      final List<String> warnings = List.from(widget.parseResult.warnings);

      await db.transaction(() async {
        // 1. Create/resolve projects
        final Map<String, String> nameToId = {};

        for (final p in widget.parseResult.projects) {
          String projectId;
          if (!p.isNew && p.existingProjectId != null) {
            projectId = p.existingProjectId!;
          } else {
            projectId = uuid.v4();
            await projectDao.insertProject(
              ProjectsCompanion.insert(
                id: projectId,
                name: p.name,
                description: Value(p.description),
                priority: Value(p.priority),
                createdAt: DateTime.now(),
                sourceImportId: Value(importId),
                colorSeed: Value(projectId.substring(0, 6)),
              ),
            );
            createdProjects++;
          }
          nameToId[p.name.toLowerCase()] = projectId;

          // 2. Ideas
          for (final ideaContent in p.ideas) {
            await ideaDao.insertIdea(
              IdeasCompanion.insert(
                id: uuid.v4(),
                content: ideaContent,
                createdAt: DateTime.now(),
                projectId: Value(projectId),
                status: const Value('linked'),
                sourceImportId: Value(importId),
              ),
            );
            createdIdeas++;
          }
        }

        // 3. Relations (resolved after all projects exist)
        for (final p in widget.parseResult.projects) {
          final fromId = nameToId[p.name.toLowerCase()];
          if (fromId == null) continue;

          for (final rel in p.relations) {
            String? toId;
            if (rel.matchedProjectId != null) {
              toId = rel.matchedProjectId;
            } else {
              // Shell project was previewed — need to check if we created it
              toId = nameToId[rel.toName.toLowerCase()];
              if (toId == null) {
                // Create shell project
                toId = uuid.v4();
                await projectDao.insertProject(
                  ProjectsCompanion.insert(
                    id: toId,
                    name: rel.toName,
                    createdAt: DateTime.now(),
                    sourceImportId: Value(importId),
                    colorSeed: Value(toId.substring(0, 6)),
                  ),
                );
                nameToId[rel.toName.toLowerCase()] = toId;
                createdProjects++;
              }
            }

            final exists = await relationDao.relationExists(fromId, toId!, rel.type);
            if (!exists) {
              await relationDao.insertRelation(
                RelationsCompanion.insert(
                  id: uuid.v4(),
                  fromId: fromId,
                  fromType: 'project',
                  toId: toId,
                  toType: 'project',
                  relationType: rel.type,
                  createdAt: DateTime.now(),
                  note: Value(rel.note),
                  sourceImportId: Value(importId),
                ),
              );
              createdRelations++;
            }
          }
        }

        // 4. YamlImport audit row
        await yamlImportDao.insertImport(
          YamlImportsCompanion.insert(
            id: importId,
            rawYaml: widget.rawYaml,
            summary: 'Created $createdProjects projects, $createdIdeas ideas, $createdRelations relations',
            importedAt: DateTime.now(),
            parseWarnings: Value(warnings.isEmpty ? null : warnings.join('\n')),
          ),
        );
      });

      if (mounted) {
        // Pop to home
        while (context.canPop()) context.pop();
        context.goNamed('home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imported: $createdProjects projects, $createdIdeas ideas, $createdRelations relations'),
            action: SnackBarAction(label: 'Undo', onPressed: () {}),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _committing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.parseResult;
    final newProjects = result.projects.where((p) => p.isNew).toList();
    final linkedProjects = result.projects.where((p) => !p.isNew).toList();
    final allIdeas = result.projects.expand((p) => p.ideas).toList();
    final allRelations = result.projects.expand((p) => p.relations).toList();

    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: const Text('Preview Import'),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (result.warnings.isNotEmpty) ...[
            _PreviewSection(
              icon: Icons.warning_amber_rounded,
              color: PulseColors.warning,
              title: 'Warnings (${result.warnings.length})',
              items: result.warnings,
            ),
            const SizedBox(height: 16),
          ],
          _PreviewSection(
            icon: Icons.add_circle_outline_rounded,
            color: PulseColors.zoneActive,
            title: 'Will Create (${newProjects.length} projects)',
            items: newProjects.map((p) => 'Project: ${p.name} [${p.priority}]').toList(),
          ),
          if (linkedProjects.isNotEmpty) ...[
            const SizedBox(height: 16),
            _PreviewSection(
              icon: Icons.link_rounded,
              color: PulseColors.accent,
              title: 'Will Link to Existing (${linkedProjects.length})',
              items: linkedProjects.map((p) => '"${p.name}" → matched existing project').toList(),
            ),
          ],
          if (allIdeas.isNotEmpty) ...[
            const SizedBox(height: 16),
            _PreviewSection(
              icon: Icons.lightbulb_outline_rounded,
              color: PulseColors.zoneDrifting,
              title: 'Ideas (${allIdeas.length})',
              items: allIdeas,
            ),
          ],
          if (allRelations.isNotEmpty) ...[
            const SizedBox(height: 16),
            _PreviewSection(
              icon: Icons.account_tree_outlined,
              color: PulseColors.edgeDependsOn,
              title: 'Relations (${allRelations.length})',
              items: allRelations.map((r) => '${r.toName} [${r.type.replaceAll("_", " ")}]${r.willCreateShell == true ? " → will create shell" : " → matched"}').toList(),
            ),
          ],
          const SizedBox(height: 32),
          Text('Nothing is written until you confirm.', style: PulseTypography.bodySmall.copyWith(color: PulseColors.textTertiary), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _committing ? null : _commit,
              child: _committing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5))
                  : const Text('Confirm Import'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.icon, required this.color, required this.title, required this.items});
  final IconData icon;
  final Color color;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PulseColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(title, style: PulseTypography.titleSmall.copyWith(color: color)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(item, style: PulseTypography.bodySmall),
          )),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
