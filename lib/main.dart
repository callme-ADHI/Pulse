import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'engine/decay/decay_job.dart';
import 'engine/notifications/notification_scheduler.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initNotifications();

  // Initialize WorkManager with our decay job dispatcher
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Register periodic decay job
  await registerDecayJob();

  // Run once on cold start if >24h stale
  // TODO Phase 5: persist lastRunAt in shared_prefs
  await runDecayJobIfStale(null);

  runApp(
    const ProviderScope(
      child: PulseApp(),
    ),
  );
}
