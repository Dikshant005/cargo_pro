import 'package:cargo_pro_assignments/controllers/auth_controllers.dart';
import 'package:cargo_pro_assignments/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/object_list_screen.dart';
import 'views/phone_input_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Custom OTP Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Obx(() {
        final authController = Get.find<AuthController>();
        return authController.isLoggedIn.value
            ? ObjectListScreen()
            : PhoneInputScreen();
      }),
    );
  }
}
