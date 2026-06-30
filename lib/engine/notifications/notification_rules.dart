/// Notification anti-spam rules from §6.6
/// Pure logic — no Flutter imports, unit-testable.
library;

class NotificationDecision {
  const NotificationDecision({required this.shouldSend, this.reason});
  final bool shouldSend;
  final String? reason;
}

abstract final class NotificationRules {
  static const int _maxPerProjectPerDay = 1;
  static const int _maxTotalPerDay = 3;
  static const int _quietHourStart = 22; // 10 PM local
  static const int _quietHourEnd = 8;   // 8 AM local

  /// Check if a project-level push can be sent.
  ///
  /// [sentTodayForProject] — how many pushes already sent for this project today.
  /// [totalSentToday] — total pushes sent today across all projects.
  /// [currentHour] — current local hour (0–23).
  static NotificationDecision canSendProjectPush({
    required int sentTodayForProject,
    required int totalSentToday,
    required int currentHour,
  }) {
    if (sentTodayForProject >= _maxPerProjectPerDay) {
      return const NotificationDecision(
        shouldSend: false,
        reason: 'Already sent max pushes for this project today',
      );
    }

    if (totalSentToday >= _maxTotalPerDay) {
      return const NotificationDecision(
        shouldSend: false,
        reason: 'Daily app-wide push cap reached; will bundle into digest',
      );
    }

    if (_isQuietHour(currentHour)) {
      return const NotificationDecision(
        shouldSend: false,
        reason: 'Quiet hours (22:00–08:00); defer to 08:00',
      );
    }

    return const NotificationDecision(shouldSend: true);
  }

  /// The weekly digest is always exempt from per-project caps.
  static NotificationDecision canSendWeeklyDigest({
    required int currentHour,
  }) {
    // Only fires at 18:00 on Sunday — enforce that at scheduler level.
    // Here just guard quiet hours (digest at 18:00 is never quiet, but defensive).
    if (_isQuietHour(currentHour)) {
      return const NotificationDecision(
        shouldSend: false,
        reason: 'Quiet hours; defer to 08:00',
      );
    }
    return const NotificationDecision(shouldSend: true);
  }

  static bool _isQuietHour(int hour) {
    if (_quietHourStart > _quietHourEnd) {
      // Wraps midnight: 22:00 to 08:00
      return hour >= _quietHourStart || hour < _quietHourEnd;
    }
    return hour >= _quietHourStart && hour < _quietHourEnd;
  }
}
