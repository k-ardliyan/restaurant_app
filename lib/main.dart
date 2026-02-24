import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/api/api_service.dart';
import 'provider/restaurant_list_provider.dart';
import 'provider/restaurant_search_provider.dart';
import 'provider/restaurant_detail_provider.dart';
import 'provider/preferences_provider.dart';
import 'ui/pages/restaurant_detail_page.dart';
import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/restaurant_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Restaurant App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: preferences.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: RestaurantListPage.routeName,
            routes: {
              RestaurantListPage.routeName: (context) =>
                  const RestaurantListPage(),
              RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                id: ModalRoute.of(context)?.settings.arguments as String,
              ),
              RestaurantSearchPage.routeName: (context) =>
                  const RestaurantSearchPage(),
            },
          );
        },
      ),
    );
  }
}
