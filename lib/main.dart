import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'core/theme/app_theme.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/database_provider.dart';
import 'provider/home_provider.dart';
import 'provider/preferences_provider.dart';
import 'provider/restaurant_detail_provider.dart';
import 'provider/restaurant_list_provider.dart';
import 'provider/restaurant_search_provider.dart';
import 'provider/scheduling_provider.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/restaurant_detail_page.dart';
import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/restaurant_search_page.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  await Workmanager().initialize(callbackDispatcher);
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  final prefs = await SharedPreferences.getInstance();

  // Re-schedule the daily reminder on startup if it was previously enabled.
  final isDailyReminderActive =
      prefs.getBool(PreferencesHelper.dailyReminder) ?? false;
  if (isDailyReminderActive) {
    try {
      await Workmanager().registerPeriodicTask(
        dailyReminderTask,
        dailyReminderTask,
        frequency: const Duration(hours: 24),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } catch (_) {
      // Reschedule failed silently; user can re-enable from settings
    }
  }

  runApp(MyApp(sharedPreferences: prefs));

  NotificationHelper().configureSelectNotificationSubject(
    RestaurantDetailPage.routeName,
    (id) {
      navigatorKey.currentState?.pushNamed(
        RestaurantDetailPage.routeName,
        arguments: {'id': id, 'heroTag': null},
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProxyProvider<ApiService, RestaurantListProvider>(
          create: (context) => RestaurantListProvider(
            apiService: Provider.of<ApiService>(context, listen: false),
          ),
          update: (context, apiService, previous) =>
              previous ?? RestaurantListProvider(apiService: apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, RestaurantSearchProvider>(
          create: (context) => RestaurantSearchProvider(
            apiService: Provider.of<ApiService>(context, listen: false),
          ),
          update: (context, apiService, previous) =>
              previous ?? RestaurantSearchProvider(apiService: apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, RestaurantDetailProvider>(
          create: (context) => RestaurantDetailProvider(
            apiService: Provider.of<ApiService>(context, listen: false),
          ),
          update: (context, apiService, previous) =>
              previous ?? RestaurantDetailProvider(apiService: apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: Future.value(sharedPreferences),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Restaurant App',
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: preferences.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              RestaurantListPage.routeName: (context) =>
                  const RestaurantListPage(),
              RestaurantDetailPage.routeName: (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args is Map) {
                  return RestaurantDetailPage(
                    id: args['id'] as String,
                    heroTag: args['heroTag'] as String?,
                  );
                }
                return RestaurantDetailPage(id: args as String);
              },
              RestaurantSearchPage.routeName: (context) =>
                  const RestaurantSearchPage(),
            },
          );
        },
      ),
    );
  }
}
