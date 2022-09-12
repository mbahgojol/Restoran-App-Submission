import 'package:flutter/material.dart';
import 'package:restoran_submision/ui/favorite/favorite_page.dart';
import 'package:restoran_submision/ui/home/list_page.dart';
import 'package:restoran_submision/ui/setting/setting_page.dart';
import 'package:restoran_submision/utils/styles.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const ListPage(),
    const FavoritePage(),
    const SettingPage()
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: ListPage.listTitle,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: FavoritePage.favoriteTitle,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: SettingPage.settingTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAndroid(context);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
