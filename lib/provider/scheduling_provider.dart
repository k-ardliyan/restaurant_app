import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../utils/background_service.dart';

class SchedulingProvider extends ChangeNotifier {
  static const int _reminderHour = 11;

  Future<bool> scheduledNews(bool value) async {
    if (value) {
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
    notifyListeners();
    return true;
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
