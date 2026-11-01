import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lorry_trip/config/routes.dart';
import 'package:lorry_trip/config/themes.dart';
import 'package:lorry_trip/native_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: MaterialApp(
        home: const NativeAndroid(),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),

      //  GetMaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   initialRoute: Routes.home,
      //   getPages: Routes.pages,
      //   theme: AppTheme.lightTheme,
      // ),
    );
  }
}
