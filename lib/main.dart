import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:house_rental_admin/core/firebase/firebase_app_check.dart';
import 'package:house_rental_admin/core/route/go_router.dart';
import 'package:house_rental_admin/core/theme/app_theme.dart';
import 'package:house_rental_admin/src/home/presentation/provider/bottom_nav_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import './firebase_options.dart';
import './locator.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheckHelper.initialise();
  final fcmToken = await _firebaseMessaging.getToken();
  print(fcmToken);
  initDependencies();

  runApp(OKToast(
    position: ToastPosition.center,
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider())
      ],
      child: MaterialApp.router(
        routerConfig: goRouter(),
        debugShowCheckedModeBanner: false,
        //home: const ConnectionPage(),
        theme: appTheme,
      ),
    ),
  ));
}
