import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../../db/database.dart';
import '../../db/daos/project_dao.dart';
import '../../db/daos/session_dao.dart';
import '../../db/daos/decay_log_dao.dart';
import 'decay_calculator.dart';
import 'package:uuid/uuid.dart';

const String kDecayJobName = 'pulse_decay_job';
const String kDecayJobTag = 'aevorax.pulse.decay';

/// WorkManager entrypoint — must be a top-level function.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == kDecayJobName) {
      await _runDecayJob();
    }
    return Future.value(true);
  });
}

Future<void> _runDecayJob() async {
  debugPrint('[DecayJob] Running decay computation...');

  final db = PulseDatabase();
  final projectDao = ProjectDao(db);
  final sessionDao = SessionDao(db);
  final decayLogDao = DecayLogDao(db);
  const uuid = Uuid();

  try {
    final projects = await projectDao.getProjectsForDecayJob();
    final now = DateTime.now();

    for (final project in projects) {
      // Determine days since last session
      final double daysSinceLast;
      if (project.lastSessionAt != null) {
        daysSinceLast =
            now.difference(project.lastSessionAt!).inMinutes / 1440.0;
      } else {
        daysSinceLast = now.difference(project.createdAt).inMinutes / 1440.0;
      }

      final input = DecayInput(
        daysSinceLastSession: daysSinceLast,
        avgGapDays: project.avgGapDays,
        priority: project.priority,
      );

      final result = DecayCalculator.compute(input);

      // Write daily snapshot
      await decayLogDao.insertLog(
        DecayLogsCompanion(
          id: Value(uuid.v4()),
          projectId: Value(project.id),
          date: Value(DateTime(now.year, now.month, now.day)),
          score: Value(result.score),
          zone: Value(result.zone),
        ),
      );

      debugPrint(
        '[DecayJob] ${project.name}: score=${result.score.toStringAsFixed(1)} zone=${result.zone}',
      );
    }

    // Hard-delete expired soft-deleted projects
    await projectDao.hardDeleteExpired();

    debugPrint('[DecayJob] Complete. Processed ${projects.length} projects.');
  } finally {
    await db.close();
  }
}

/// Register the daily WorkManager job.
Future<void> registerDecayJob() async {
  await Workmanager().registerPeriodicTask(
    kDecayJobName,
    kDecayJobName,
    tag: kDecayJobTag,
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 5),
    constraints: Constraints(networkType: NetworkType.notRequired),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

/// Run once on cold start if last run was >24h ago.
Future<void> runDecayJobIfStale(DateTime? lastRunAt) async {
  if (lastRunAt == null ||
      DateTime.now().difference(lastRunAt) > const Duration(hours: 24)) {
    await _runDecayJob();
  }
}
