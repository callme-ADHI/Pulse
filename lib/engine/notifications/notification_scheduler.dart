import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz_data.initializeTimeZones();
  final localTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const linuxSettings = LinuxInitializationSettings(
    defaultActionName: 'Open',
  );
  const initSettings = InitializationSettings(
    android: androidSettings,
    linux: linuxSettings,
  );

  await _notifications.initialize(settings: initSettings);
}

const AndroidNotificationDetails _androidChannel = AndroidNotificationDetails(
  'pulse_nudges',
  'Pulse Nudges',
  channelDescription: 'Project momentum alerts from Pulse',
  importance: Importance.defaultImportance,
  priority: Priority.defaultPriority,
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
    'cold' => '$projectName hasn\'t had a session in a while.',
    'critical' =>
      '$projectName is in the critical zone. Consider picking it up.',
    _ => '$projectName is drifting.',
  };

  await _notifications.show(
    id: id,
    title: 'Pulse',
    body: body,
    notificationDetails: const NotificationDetails(
      android: _androidChannel,
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
