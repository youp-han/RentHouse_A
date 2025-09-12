import 'package:flutter/material.dart';
import 'package:renthouse/core/logging/crash_consent_wrapper.dart';
import 'theme.dart';
import 'router.dart';

class RentHouseApp extends StatelessWidget {
  const RentHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CrashConsentWrapper(
      child: MaterialApp.router(
        title: 'RentHouse',
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
