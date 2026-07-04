import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
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
  bool    _parsing   = false;

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
    if (_syntaxError != null) setState(() => _syntaxError = null);
  }

  Future<void> _parse() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _parsing = true);

    try {
      final projectDao  = ref.read(projectDaoProvider);
      final allProjects = await projectDao.getAllActiveProjectsList();
      final existingMap = {for (final p in allProjects) p.name.toLowerCase(): p.id};

      final parser = YamlParser();
      final result = parser.parse(text, existingMap);

      if (mounted) {
        context.pushNamed(
          'importPreview',
          extra: {'rawYaml': text, 'parseResult': result},
        );
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text('Import YAML Plan', style: AppText.title()),
        centerTitle: false,
        actions: [
          if (!_parsing && _syntaxError == null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: _parse,
                child: Text(
                  'Parse',
                  style: AppText.titleSmall().copyWith(color: AppColors.gold),
                ),
              ),
            ),
          if (_parsing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: AppColors.gold),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Syntax error banner ──────────────────────────────────────
          if (_syntaxError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.zoneCriticalBg,
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.zoneCriticalFg,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _syntaxError!,
                      style: AppText.body()
                          .copyWith(color: AppColors.zoneCriticalFg, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // ── Monospace editor ─────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDim.pad16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: AppText.monoSmall().copyWith(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText:
                      '# Paste your AI-generated YAML plan here\n'
                      'project:\n'
                      '  name: "My Project"\n'
                      '  weight: 2.0\n'
                      '  estimated_hours: 40\n'
                      '  phases:\n'
                      '    - name: "Phase 1"\n'
                      '  ideas:\n'
                      '    - "First idea"',
                  hintStyle:
                      AppText.body().copyWith(color: AppColors.textMuted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
              ),
            ),
          ),

          // ── Bottom action bar ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderDefault),
              ),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => _showSchemaSheet(context),
                  child: Text(
                    'View schema',
                    style: AppText.body()
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDim.radiusBtn),
                      ),
                    ),
                    onPressed: _parsing ? null : _parse,
                    child: _parsing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5, color: AppColors.gold),
                          )
                        : const Text('Parse & Preview'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSchemaSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SchemaSheet(),
    );
  }
}

class _SchemaSheet extends StatelessWidget {
  const _SchemaSheet();

  static const _schema = '''project:
  name: "Project Name"          # required
  description: "What it is"    # optional
  weight: 2.0                   # 0.1 – 5.0  (default 1.0)
  estimated_hours: 40           # optional
  phases:                       # descriptive milestones
    - name: "Phase name"
      summary: "What happens"
  learning_goals:               # skills to pick up
    - "Learn Riverpod"
  ideas:                        # become linked Inbox ideas
    - "First idea"
  relations:                    # graph edges
    - to: "Other Project"
      type: related_to          # depends_on|blocks|inspired_by|part_of|related_to
      note: "Optional"

# Multi-project: wrap in "projects:" list''';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppDim.pad20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Accepted Schema', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          Container(
            padding: const EdgeInsets.all(AppDim.pad16),
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(AppDim.radiusCard),
            ),
            child: Text(
              _schema,
              style: AppText.monoSmall().copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: AppDim.pad20),
        ],
      ),
    );
  }
}
