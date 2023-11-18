import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/core/network_info.dart';
import 'package:smile/core/prefutils.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/authentication/loginscreen.dart';
import 'package:smile/presentation/screens/authentication/splash.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingh_history_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => NetworkInfo(Connectivity()));
        Get.put(() => PrefUtils());
      }),
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
    );
  }
}

