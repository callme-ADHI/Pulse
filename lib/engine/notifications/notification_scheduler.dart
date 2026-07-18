import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  try {
    tz_data.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));
  } catch (e) {
    debugPrint('Timezone initialization failed: $e. Falling back to UTC.');
    try {
      tz.setLocalLocation(tz.getLocation('UTC'));
    } catch (_) {}
  }

  const androidSettings = AndroidInitializationSettings('ic_stat_pulse');
  const linuxSettings = LinuxInitializationSettings(
    defaultActionName: 'Open',
  );
  const initSettings = InitializationSettings(
    android: androidSettings,
    linux: linuxSettings,
  );

  await _notifications.initialize(settings: initSettings);

  // Request notifications permission for Android 13+
  await _notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

const AndroidNotificationDetails _androidChannel = AndroidNotificationDetails(
  'pulse_nudges',
  'Pulse Nudges',
  channelDescription: 'Project momentum alerts from Pulse',
  importance: Importance.defaultImportance,
  priority: Priority.defaultPriority,
  icon: 'ic_stat_pulse',
  playSound: false,
  enableVibration: false,
);

const LinuxNotificationDetails _linuxDetails = LinuxNotificationDetails();

Future<void> sendProjectNudge({
  required int id,
  required String projectName,
  required String zone,
}) async {
  final body = switch (zone) {
    'cold'     => '$projectName hasn\'t had a session in a while.',
    'critical' => '$projectName is in the critical zone. Consider picking it up.',
    _          => '$projectName is drifting. Keep the momentum going.',
  };

  final androidDetails = AndroidNotificationDetails(
    'pulse_nudges',
    'Pulse Nudges',
    channelDescription: 'Project momentum alerts from Pulse',
    icon: 'ic_stat_pulse',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    playSound: false,
    enableVibration: false,
    category: AndroidNotificationCategory.reminder,
  );

  await _notifications.show(
    id: id,
    title: '⚡ Pulse',
    body: body,
    notificationDetails: NotificationDetails(
      android: androidDetails,
      linux: _linuxDetails,
    ),
  );
}

Future<void> sendPhaseDeadlineNotification({
  required int id,
  required String phaseName,
  required String projectName,
  required DateTime deadline,
}) async {
  final overdueDays = DateTime.now().difference(deadline).inDays;
  final dueLabel = overdueDays == 0
      ? 'due today'
      : '$overdueDays day${overdueDays == 1 ? '' : 's'} overdue';

  final androidDetails = AndroidNotificationDetails(
    'pulse_deadlines',
    'Phase Deadlines',
    channelDescription: 'Phase deadline alerts from Pulse',
    icon: 'ic_stat_pulse',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    category: AndroidNotificationCategory.reminder,
    color: const Color(0xFFC9A84C),
  );

  await _notifications.show(
    id: id,
    title: '⏰ Phase Overdue — $projectName',
    body: '"$phaseName" is $dueLabel.',
    notificationDetails: NotificationDetails(
      android: androidDetails,
      linux: _linuxDetails,
    ),
  );
}

Future<void> sendWeeklyDigest({
  required String summary,
}) async {
  await _notifications.show(
    id: 9999,
    title: 'Weekly Pulse Digest',
    body: summary,
    notificationDetails: const NotificationDetails(
      android: _androidChannel,
      linux: _linuxDetails,
    ),
  );
}

Future<void> showActiveSessionNotification({
  required String projectName,
  required DateTime startedAt,
}) async {
  final androidDetails = AndroidNotificationDetails(
    'active_session',
    'Active Session',
    channelDescription: 'Ongoing work sessions in Pulse',
    icon: 'ic_stat_pulse',
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
    onlyAlertOnce: true,
    playSound: false,
    enableVibration: false,
    showWhen: true,
    usesChronometer: true,
    when: startedAt.millisecondsSinceEpoch,
  );
  await _notifications.show(
    id: 10001,
    title: 'Pulse — Active Session',
    body: projectName,
    notificationDetails: NotificationDetails(
      android: androidDetails,
      linux: const LinuxNotificationDetails(),
    ),
  );
}

Future<void> cancelActiveSessionNotification() async {
  await _notifications.cancel(id: 10001);
}
