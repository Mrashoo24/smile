import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/core/network_info.dart';
import 'package:smile/core/prefutils.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/authentication/splash.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
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

