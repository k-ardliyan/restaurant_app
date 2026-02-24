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
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Theme'),
                subtitle: const Text('Enable dark mode UI'),
                value: provider.isDarkTheme,
                onChanged: (value) {
                  provider.enableDarkTheme(value);
                },
              ),
              const Divider(),
              Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return SwitchListTile(
                    title: const Text('Restaurant Notification'),
                    subtitle: const Text('Enable daily reminder at 11:00 AM'),
                    value: provider.isDailyReminderActive,
                    onChanged: (value) async {
                      provider.enableDailyReminder(value);
                      scheduled.scheduledNews(value);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
