import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'db/database.dart';
import 'providers.dart';
import 'engine/decay/decay_job.dart';
import 'engine/notifications/notification_scheduler.dart';
import 'engine/session/session_lifecycle_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize notifications safely
  try {
    await initNotifications();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }

  // 2. Initialize WorkManager safely
  try {
    await Workmanager().initialize(callbackDispatcher);
    await registerDecayJob();
  } catch (e) {
    debugPrint('Failed to initialize WorkManager: $e');
  }

  // 3. Create the single shared DB instance
  final db = PulseDatabase();

  // 4. Session recovery safely
  try {
    await SessionLifecycleService.recoverOrphanedSession(db);
  } catch (e) {
    debugPrint('Failed to recover orphaned session: $e');
  }

  // 5. Run decay job check safely
  try {
    await runDecayJobIfStale(null);
  } catch (e) {
    debugPrint('Failed to run decay check: $e');
  }

  // 6. Register lifecycle observer
  final lifecycleService = SessionLifecycleService(db);
  WidgetsBinding.instance.addObserver(lifecycleService);
  // Kick off heartbeat immediately (app is already in resumed state).
  lifecycleService.didChangeAppLifecycleState(AppLifecycleState.resumed);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const PulseApp(),
    ),
  );
}
