import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restoran_submision/data/api/api_service.dart';
import 'package:restoran_submision/data/model/restaurants.dart';
import 'package:restoran_submision/data/pref/shared_pref.dart';
import 'package:restoran_submision/provider/database_provider.dart';
import 'package:restoran_submision/provider/preferences_provider.dart';
import 'package:restoran_submision/ui/detail/detail_page.dart';
import 'package:restoran_submision/ui/home/home_page.dart';
import 'package:restoran_submision/ui/home/home_page_provider.dart';
import 'package:restoran_submision/ui/search/search_page.dart';
import 'package:restoran_submision/ui/search/search_page_provider.dart';
import 'package:restoran_submision/ui/splash/splash_page.dart';
import 'package:restoran_submision/utils/background_service.dart';
import 'package:restoran_submision/utils/navigation.dart';
import 'package:restoran_submision/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/db/db_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomePageProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (_) => SearchPageProvider(apiService: ApiService())),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
                    preferencesHelper: SharedPref(
                  sharedPreferences: SharedPreferences.getInstance(),
                )))
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Restoran App',
            theme: provider.themeData,
            navigatorKey: navigatorKey,
            initialRoute: SplashPage.routeName,
            routes: {
              SplashPage.routeName: (context) => const SplashPage(),
              SearchPage.routeName: (context) => const SearchPage(),
              HomePage.routeName: (context) => const HomePage(),
              DetailPage.routeName: (context) => DetailPage(
                  restaurants:
                      ModalRoute.of(context)?.settings.arguments as Restaurant)
            },
          );
        },
      ),
    );
  }
}
