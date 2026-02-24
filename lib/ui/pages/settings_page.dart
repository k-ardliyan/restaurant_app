import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/preferences_provider.dart';
import '../../provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer2<PreferencesProvider, SchedulingProvider>(
        builder: (_, preferences, scheduled, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Theme'),
                subtitle: const Text('Enable dark mode UI'),
                value: preferences.isDarkTheme,
                onChanged: preferences.enableDarkTheme,
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Restaurant Notification'),
                subtitle: const Text('Enable daily reminder at 11:00 AM'),
                value: preferences.isDailyReminderActive,
                onChanged: (value) async {
                  final success = await scheduled.scheduledNews(value);
                  if (success) {
                    preferences.enableDailyReminder(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
