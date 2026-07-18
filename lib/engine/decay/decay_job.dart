import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../../db/database.dart';
import '../../db/daos/project_dao.dart';
import '../../db/daos/decay_log_dao.dart';
import '../../db/daos/dead_time_dao.dart';
import '../../db/daos/phase_dao.dart';
import 'decay_calculator.dart';
import '../notifications/notification_scheduler.dart';
import 'package:uuid/uuid.dart';

const String kDecayJobName = 'pulse_decay_job';
const String kDecayJobTag  = 'aevorax.pulse.decay';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == kDecayJobName) await _runDecayJob();
    return true;
  });
}

Future<void> _runDecayJob() async {
  debugPrint('[DecayJob] Running...');
  final db = PulseDatabase();
  final projectDao  = ProjectDao(db);
  final decayLogDao = DecayLogDao(db);
  final deadTimeDao = DeadTimeDao(db);
  final phaseDao    = PhaseDao(db);
  const uuid = Uuid();

  try {
    // ── 1. Decay scoring ────────────────────────────────────────────────────
    final projects = await projectDao.getProjectsForDecayJob();
    final now = DateTime.now();

    for (final project in projects) {
      final rawDeadTimes = await deadTimeDao.getDeadTimesForProject(project.id);
      final deadPeriods  = rawDeadTimes.map((dt) => DeadPeriod(
        fromDate: dt.fromDate,
        toDate:   dt.toDate,
      )).toList();

      final input = DecayInput(
        lastSessionAt:    project.lastSessionAt,
        projectCreatedAt: project.createdAt,
        avgGapDays:       project.avgGapDays,
        weight:           project.weight,
        deadPeriods:      deadPeriods,
      );

      final result = DecayCalculator.compute(input);

      await decayLogDao.insertLog(
        DecayLogsCompanion(
          id:        Value(uuid.v4()),
          projectId: Value(project.id),
          date:      Value(DateTime(now.year, now.month, now.day)),
          score:     Value(result.score),
          zone:      Value(result.zone),
        ),
      );

      // ── Fire nudge notification for drifting/cold/critical projects ───────
      if (result.zone == 'cold' || result.zone == 'critical' || result.zone == 'drifting') {
        // Use a stable numeric id derived from the project id hash
        final notifId = project.id.hashCode.abs() % 100000;
        try {
          await sendProjectNudge(
            id: notifId,
            projectName: project.name,
            zone: result.zone,
          );
        } catch (e) {
          debugPrint('[DecayJob] Failed to send nudge for ${project.name}: $e');
        }
      }

      debugPrint('[DecayJob] ${project.name}: ${result.score.toStringAsFixed(1)} (${result.zone})');
    }

    await projectDao.hardDeleteExpired();

    // ── 2. Phase deadline check ────────────────────────────────────────────
    try {
      final overduePhases = await phaseDao.getOverduePhases();
      for (final phase in overduePhases) {
        // Mark phase as delayed
        await phaseDao.markPhaseDelayed(phase.id);

        // Look up project name for the notification
        final project = await projectDao.getProjectById(phase.projectId);
        final projectName = project?.name ?? 'Project';
        final notifId = (phase.id.hashCode.abs() % 100000) + 200000;

        try {
          await sendPhaseDeadlineNotification(
            id: notifId,
            phaseName: phase.name,
            projectName: projectName,
            deadline: phase.deadline!,
          );
        } catch (e) {
          debugPrint('[DecayJob] Phase deadline notif failed for ${phase.name}: $e');
        }

        debugPrint('[DecayJob] Phase "${phase.name}" in $projectName is overdue — marked delayed.');
      }
    } catch (e) {
      debugPrint('[DecayJob] Phase deadline check failed: $e');
    }

    debugPrint('[DecayJob] Done. ${projects.length} projects processed.');
  } finally {
    await db.close();
  }
}

Future<void> registerDecayJob() async {
  await Workmanager().registerPeriodicTask(
    kDecayJobName, kDecayJobName,
    tag:               kDecayJobTag,
    frequency:         const Duration(hours: 24),
    initialDelay:      const Duration(minutes: 5),
    constraints:       Constraints(networkType: NetworkType.notRequired),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

Future<void> runDecayJobIfStale(DateTime? lastRunAt) async {
  if (lastRunAt == null ||
      DateTime.now().difference(lastRunAt) > const Duration(hours: 24)) {
    await _runDecayJob();
  }
}
