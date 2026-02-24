import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import '../data/api/api_service.dart';
import 'notification_helper.dart';

const String dailyReminderTask = 'daily_restaurant_reminder';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      final NotificationHelper notificationHelper = NotificationHelper();

      await notificationHelper.initNotifications(notificationsPlugin);

      final result = await ApiService().getRestaurantList();
      if (!result.error && result.restaurants.isNotEmpty) {
        final randomList = result.restaurants.toList()..shuffle();
        await notificationHelper.showNotification(
          notificationsPlugin,
          randomList.first,
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  });
}
