import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/zone_badge.dart';
import '../home/home_providers.dart';

// ════════════════════════════════════════════════════════════════════════════
// PROJECTS SCREEN — full project list with drop action
// ════════════════════════════════════════════════════════════════════════════

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final enrichedAsync = ref.watch(enrichedAllProjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROJECTS', style: AppText.display().copyWith(fontSize: 22)),
                      Text('All active & paused', style: AppText.label().copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/archive'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                      ),
                      child: Text('Archive', style: AppText.label().copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.push('/new-project'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                      ),
                      child: Text('+ New', style: AppText.label().copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                children: [
                  _buildChip('all', 'All'),
                  _buildChip('active', 'Active'),
                  _buildChip('drifting', 'Drifting'),
                  _buildChip('cold', 'Cold'),
                  _buildChip('critical', 'Critical'),
                  _buildChip('paused', 'Paused'),
                  _buildChip('dropped', 'Dropped'),
                ],
              ),
            ),

            // List
            Expanded(
              child: enrichedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
                error: (e, _) => Center(child: Text('Error: $e', style: AppText.body())),
                data: (list) {
                  if (list.isEmpty) return _Empty(message: 'No projects yet');

                  final filteredList = switch (_filter) {
                    'all'      => list,
                    'paused'   => list.where((p) => p.project.status == 'paused').toList(),
                    'dropped'  => list.where((p) => p.project.status == 'dropped').toList(),
                    _          => list.where((p) => p.zone == _filter).toList(),
                  };

                  if (filteredList.isEmpty) {
                    return _Empty(message: 'No projects in this category');
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    itemCount: filteredList.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ProjectRow(item: filteredList[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String value, String label) {
    final isSel = value == _filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSel ? AppColors.gold : AppColors.surface1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSel ? AppColors.gold : AppColors.borderDefault),
        ),
        child: Text(label, style: AppText.label().copyWith(
          color: isSel ? Colors.black : AppColors.textSecondary,
          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
        )),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PROJECT ROW
// ════════════════════════════════════════════════════════════════════════════

class _ProjectRow extends ConsumerWidget {
  const _ProjectRow({required this.item});
  final ProjectWithDecay item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p     = item.project;
    final score = item.score;
    final zone  = item.zone;

    return Dismissible(
      key: ValueKey(p.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF3A1010),
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block_rounded, color: Color(0xFFC93030), size: 22),
            SizedBox(height: 4),
            Text('DROP', style: TextStyle(color: Color(0xFFC93030), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        final reason = await _showDropDialog(context, p.name);
        if (reason == null) return false;
        await ref.read(projectDaoProvider).dropProject(p.id, reason);
        return false; // we handle it ourselves
      },
      child: GestureDetector(
        onTap: () => context.push('/project/${p.id}'),
        onLongPress: () async {
          final reason = await _showDropDialog(context, p.name);
          if (reason != null) await ref.read(projectDaoProvider).dropProject(p.id, reason);
        },
        child: Container(
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
                children: [
                  Expanded(child: Text(p.name, style: AppText.bodyWhite().copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  ZoneBadge(zone: zone),
                ],
              ),
              if (p.description != null && p.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(p.description!, style: AppText.body(), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  _Stat(label: 'DECAY', value: score.toString()),
                  const SizedBox(width: 16),
                  _Stat(label: 'WEIGHT', value: p.weight.toStringAsFixed(1)),
                  if (p.endDate != null) ...[
                    const SizedBox(width: 16),
                    _DeadlineChip(endDate: p.endDate!),
                  ],
                  const Spacer(),
                  if (p.status == 'paused')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1505),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFC9A84C).withValues(alpha: 0.4)),
                      ),
                      child: const Text('PAUSED', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppText.label().copyWith(fontSize: 9, color: AppColors.textMuted)),
      Text(value, style: AppText.monoSmall()),
    ],
  );
}

class _DeadlineChip extends StatelessWidget {
  final DateTime endDate;
  const _DeadlineChip({required this.endDate});
  @override
  Widget build(BuildContext context) {
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    final overdue  = daysLeft < 0;
    final urgent   = !overdue && daysLeft <= 7;
    final color    = overdue ? const Color(0xFFC93030) : (urgent ? const Color(0xFFC9601D) : AppColors.textSecondary);
    return Row(
      children: [
        Icon(Icons.flag_rounded, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          overdue ? '${-daysLeft}d overdue' : (daysLeft == 0 ? 'Today!' : '${daysLeft}d left'),
          style: AppText.label().copyWith(fontSize: 9, color: color),
        ),
      ],
    );
  }
}

Future<String?> _showDropDialog(BuildContext context, String projectName) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Drop "$projectName"?', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dropped projects are removed from active lists but preserved in the archive with their reason.', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 16),
          const Text('REASON (OPTIONAL)', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            autofocus: true,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Why are you dropping this? (optional)',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFC93030), width: 1.0)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
        TextButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim().isEmpty ? 'No reason given' : ctrl.text.trim()),
          child: const Text('DROP IT', style: TextStyle(color: Color(0xFFC93030), fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ),
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.dashboard_outlined, size: 48, color: AppColors.textMuted),
        const SizedBox(height: 16),
        Text(message, style: AppText.body()),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => context.push('/new-project'),
          child: Text('Create one →', style: AppText.body().copyWith(color: AppColors.gold)),
        ),
      ],
    ),
  );
}
