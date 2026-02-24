import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../utils/background_service.dart';
import '../utils/notification_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  static const int _reminderHour = 11;

  Future<bool> scheduledNews(bool value) async {
    try {
      if (value) {
        final granted = await NotificationHelper()
            .requestAndroidNotificationPermission();
        if (!granted) return false;

        await Workmanager().registerPeriodicTask(
          dailyReminderTask,
          dailyReminderTask,
          frequency: const Duration(hours: 24),
          initialDelay: _calculateInitialDelay(),
          constraints: Constraints(networkType: NetworkType.connected),
          existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
        );
      } else {
        await Workmanager().cancelByUniqueName(dailyReminderTask);
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var reminderTime = DateTime(now.year, now.month, now.day, _reminderHour);
    if (!reminderTime.isAfter(now)) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }
    return reminderTime.difference(now);
  }
}
