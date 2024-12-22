// import 'package:application_1/pages/home_page.dart';
import 'package:application_1/pages/onboard_page.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const RescueApp());
}

class RescueApp extends StatelessWidget {
  const RescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rescue App',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
