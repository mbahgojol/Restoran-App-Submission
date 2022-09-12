import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restoran_submision/data/pref/shared_pref.dart';
import 'package:restoran_submision/utils/styles.dart';

import '../utils/background_service.dart';
import '../utils/date_time_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  SharedPref preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getRememberPreferences();
  }

  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void _getRememberPreferences() async {
    _isScheduled = await preferencesHelper.isReminder;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void enableRemember(bool value) {
    preferencesHelper.setReminder(value);
    _scheduledRestaurans(value);
    _getRememberPreferences();
  }

  Future<bool> _scheduledRestaurans(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Restaurans Activated');
      notifyListeners();
      print(DateTimeHelper.format());
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Restaurans Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
