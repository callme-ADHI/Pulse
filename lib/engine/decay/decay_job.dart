import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../../db/database.dart';
import '../../db/daos/project_dao.dart';
import '../../db/daos/decay_log_dao.dart';
import '../../db/daos/dead_time_dao.dart';
import 'decay_calculator.dart';
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
  const uuid = Uuid();

  try {
    final projects = await projectDao.getProjectsForDecayJob();
    final now = DateTime.now();

    for (final project in projects) {
      // Load dead times for this project
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

      debugPrint('[DecayJob] ${project.name}: ${result.score.toStringAsFixed(1)} (${result.zone})');
    }

    await projectDao.hardDeleteExpired();
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
