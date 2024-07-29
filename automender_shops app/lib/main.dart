import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = Get.put(AuthController());
  await authController.loadToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AutoMender Shops',
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
        
    );
  }
}
