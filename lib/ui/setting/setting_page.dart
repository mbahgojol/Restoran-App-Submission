import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/preferences_provider.dart';

class SettingPage extends StatelessWidget {
  static const String settingTitle = 'Setting';

  const SettingPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                  title: const Text('Restaurant Notification'),
                  subtitle: const Text('Enable notification'),
                  trailing: Switch.adaptive(
                    value: provider.isScheduled,
                    onChanged: (value) async {
                      provider.enableRemember(value);
                    },
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAndroid(context);
  }
}
