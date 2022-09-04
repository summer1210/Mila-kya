import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:lost_found_app/screens/onboarding_screen.dart';
import 'package:lost_found_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/root_screen.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

UserModel user;
Future<void> main() async {
  GoogleMap.init('API_KEY');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString('userData') != null) {
    print(pref.getString('userData'));
    Map json = jsonDecode(pref.getString('userData'));
    user = UserModel.fromJson(json);
  }

  runApp(MyApp(
    screen:
        pref.getString('userData') == null ? OnboardingScreen() : RootScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget screen;

  MyApp({this.screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: 1.0, alwaysUse24HourFormat: false),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        screen: screen,
      ),
    );
  }
}
