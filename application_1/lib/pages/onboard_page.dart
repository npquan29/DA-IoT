import 'package:application_1/pages/home_page.dart';
import 'package:application_1/pages/login_page.dart';
import 'package:application_1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    _requestLocationPermission();

    _navigateAfterOnboarding();

    // Đặt thời gian chờ 3 giây và sau đó chuyển sang màn Home
    // Timer(const Duration(seconds: 3, milliseconds: 500), () {
    //   Navigator.pushReplacement(
    //       context, CustomPageRoute(child: const HomeScreen()));
    // });
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Dịch vụ vị trí chưa được bật.");
      return;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Quyền truy cập vị trí bị từ chối.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Quyền truy cập vị trí bị từ chối vĩnh viễn.");
      return;
    }

    print("Quyền truy cập vị trí đã được cấp.");
  }

  Future<void> _navigateAfterOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kColorBluePrimary,
            kColorBlueSecondary,
          ],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/rescue.png",
                width: 0.6 * size.width,
              ),
              const SizedBox(
                height: 8,
              ),
              Text('Rescue App'.toUpperCase(),
                  style: PrimaryFont.bold(40).copyWith(
                    color: kColorRed,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
