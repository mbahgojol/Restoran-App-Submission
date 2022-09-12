import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restoran_submision/ui/home/home_page.dart';

class SplashPage extends StatelessWidget {
  static const routeName = "/splash";

  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
    return Container(
      color: Colors.white,
      child: Center(
          child: Image.asset(
        "assets/restaurant.png",
        width: 200,
        height: 200,
      )),
    );
  }
}
