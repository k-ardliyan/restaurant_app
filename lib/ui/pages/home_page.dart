import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/home_provider.dart';
import 'restaurant_list_page.dart';
import 'favorite_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  static const List<Widget> _pages = [
    RestaurantListPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Restaurants'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: IndexedStack(index: provider.selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.selectedIndex,
            items: _bottomNavBarItems,
            onTap: provider.setIndex,
          ),
        );
      },
    );
  }
}
