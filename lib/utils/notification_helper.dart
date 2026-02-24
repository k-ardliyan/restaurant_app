import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/models/restaurant.dart';

final selectNotificationSubject = StreamController<String>.broadcast();

class NotificationHelper {
  static NotificationHelper? _instance;
  FlutterLocalNotificationsPlugin? _plugin;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() {
    return _instance ?? NotificationHelper._internal();
  }

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    _plugin = flutterLocalNotificationsPlugin;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _plugin!.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        final payload = details.payload;
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  /// Requests notification permission on Android 13+.
  /// Returns [true] if granted (or platform is not Android), [false] if denied.
  Future<bool> requestAndroidNotificationPermission() async {
    final granted = await _plugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    return granted ?? true;
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurant restaurant,
  ) async {
    const channelId = '1';
    const channelName = 'channel_01';
    const channelDescription = 'restaurant recommendations channel';

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    const titleNotification = '<b>Recommended Restaurant</b>';
    final titleNews = restaurant.name;

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: titleNotification,
      body: titleNews,
      notificationDetails: platformChannelSpecifics,
      payload: json.encode(restaurant.toJson()),
    );
  }

  StreamSubscription<String>? _notificationSubscription;

  void configureSelectNotificationSubject(
    String route,
    Function(String) navigate,
  ) {
    _notificationSubscription?.cancel();
    _notificationSubscription = selectNotificationSubject.stream.listen((
      String payload,
    ) {
      try {
        final data = Restaurant.fromJson(json.decode(payload));
        navigate(data.id);
      } catch (_) {
        // Ignore malformed payload
      }
    });
  }
}
