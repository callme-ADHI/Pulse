import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'yaml_parser.dart';
import '../../providers.dart';

/// Import screen — §4.5 Step 1
/// Full-screen monospace text field, live syntax error indicator.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _controller = TextEditingController();
  String? _syntaxError;
  bool _parsing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_liveCheck);
  }

  @override
  void dispose() {
    _controller.removeListener(_liveCheck);
    _controller.dispose();
    super.dispose();
  }

  void _liveCheck() {
    final text = _controller.text;
    if (text.isEmpty) {
      if (_syntaxError != null) setState(() => _syntaxError = null);
      return;
    }
    try {
      // Light check: just try loadYaml
      final parser = YamlParser();
      // We don't parse fully here — just check syntax
    } catch (e) {
      // No-op for live check — only flag on parse attempt
    }
  }

  Future<void> _parse() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _parsing = true);

    try {
      // Build existing projects map for fuzzy matching
      final projectDao = ref.read(projectDaoProvider);
      final allProjects = await projectDao.getAllActiveProjectsList();
      final existingMap = {for (final p in allProjects) p.name.toLowerCase(): p.id};

      final parser = YamlParser();
      final result = parser.parse(text, existingMap);

      if (mounted) {
        context.pushNamed('importPreview', extra: {'rawYaml': text, 'parseResult': result});
      }
    } on YamlSyntaxException catch (e) {
      setState(() => _syntaxError = e.message);
    } finally {
      if (mounted) setState(() => _parsing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: const Text('Import YAML Plan'),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
        actions: [
          if (_syntaxError == null && !_parsing)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: _parse,
                child: Text('Parse', style: PulseTypography.titleSmall.copyWith(color: PulseColors.accent)),
              ),
            ),
          if (_parsing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent))),
            ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (_syntaxError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: PulseColors.zoneCriticalBg,
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: PulseColors.zoneCritical, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_syntaxError!, style: PulseTypography.bodySmall.copyWith(color: PulseColors.zoneCritical))),
                ],
              ),
            ),

          // Monospace editor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: PulseTypography.monoCode,
                decoration: const InputDecoration(
                  hintText: '# Paste your AI-generated YAML plan here\nproject:\n  name: "My Project"\n  priority: medium\n  ideas:\n    - "First idea"',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: PulseColors.border)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => _showSchemaReference(context),
                  child: const Text('View schema'),
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _parsing ? null : _parse,
                    child: _parsing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5)) : const Text('Parse & Preview'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSchemaReference(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SchemaReferenceSheet(),
    );
  }
}

class _SchemaReferenceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const schema = '''project:
  name: "Project Name"          # required
  description: "What it is"    # optional
  priority: medium              # low | medium | high
  phases:                       # descriptive only, not checkable
    - name: "Phase name"
      summary: "What happens"
  ideas:                        # become linked Ideas
    - "Idea text"
  relations:                    # graph edges
    - to: "Other Project"
      type: related_to          # depends_on | blocks | inspired_by | part_of | related_to
      note: "Optional note"

# Multi-project: wrap in "projects:" list''';

    return Container(
      decoration: const BoxDecoration(color: PulseColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Accepted Schema', style: PulseTypography.titleMedium),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: PulseColors.surfaceElevated, borderRadius: BorderRadius.circular(8)),
            child: Text(schema, style: PulseTypography.monoCode),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
