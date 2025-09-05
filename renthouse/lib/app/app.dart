import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

class RentHouseApp extends StatelessWidget {
  const RentHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RentHouse',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
